// ignore_for_file: avoid_print
import 'dart:io';

/// UI Screen Toolkit — Analyzer + Fixer + Widget Extractor
///
/// Two modes in one script:
///
/// ─── MODE 1: analyze (default) ─────────────────────────────────────────────
///   Scans every Dart file inside a feature's `ui/` directory and reports
///   violations of AI_GENERAL_PROMPT_FOR_DESIGN_GUIDE.md.
///   Pass `--fix` to auto-correct safe violations (spacing rules).
///
///   dart run lib/core/tools/mcp/ui_toolkit.dart analyze <feature_name> [--fix]
///
/// ─── MODE 2: extract ───────────────────────────────────────────────────────
///   Reads a screen file, finds every `/// @widget_ex ==> <Name>` annotation,
///   extracts the annotated widget into `widgets/<name>.dart` as a `part` file,
///   and wraps the call-site in the main screen with `Semantics(label: '...')`.
///   No Semantics goes inside the extracted widget — it stays in the screen.
///
///   dart run lib/core/tools/mcp/ui_toolkit.dart extract <path_to_screen_file>
///
/// Examples:
///   dart run lib/core/tools/mcp/ui_toolkit.dart analyze main_screen --fix
///   dart run lib/core/tools/mcp/ui_toolkit.dart extract lib/features/screens/main_screen/ui/main_screen/main_screen_screen.dart

// ═══════════════════════════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════════════════════════

String _toPascal(String s) => s
    .split(RegExp(r'[\s_]+'))
    .where((w) => w.isNotEmpty)
    .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
    .join('');

String _toSnake(String s) => s
    .replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m.group(0)!.toLowerCase()}')
    .replaceFirst(RegExp(r'^_'), '')
    .replaceAll(RegExp(r'\s+'), '_')
    .toLowerCase();

/// Walk backwards from [openIdx] to grab the widget/class name before the `(`.
String _widgetNameBefore(String src, int openIdx) {
  if (openIdx == 0) return '';
  int i = openIdx - 1;
  while (i >= 0 && src[i] == ' ') i--;
  int end = i;
  while (i >= 0 && RegExp(r'[a-zA-Z0-9_.]').hasMatch(src[i])) i--;
  return src.substring(i + 1, end + 1);
}

/// Extract a balanced `(…)` expression starting at or after [startIndex].
String _extractBalanced(String src, int startIndex) {
  final openIdx = src.indexOf('(', startIndex);
  if (openIdx == -1) return src.substring(startIndex).trim();

  int depth = 0;
  int end = openIdx;
  for (int i = openIdx; i < src.length; i++) {
    if (src[i] == '(') depth++;
    if (src[i] == ')') {
      depth--;
      if (depth == 0) { end = i; break; }
    }
  }
  return src.substring(openIdx - _widgetNameBefore(src, openIdx).length, end + 1).trim();
}

// ═══════════════════════════════════════════════════════════════════════════════
// EXTRACTION MODEL
// ═══════════════════════════════════════════════════════════════════════════════

class _Extraction {
  _Extraction({
    required this.annotationLineIdx,
    required this.widgetLineIdx,
    required this.widgetCode,
    required this.cleanWidgetCode,
    required this.indent,
    required this.pascalName,
    required this.snakeName,
  });

  final int annotationLineIdx;
  final int widgetLineIdx;
  final String widgetCode;
  final String cleanWidgetCode;
  final String indent;
  final String pascalName;
  final String snakeName;
  int widgetEndLineIdx = 0;
}

// ═══════════════════════════════════════════════════════════════════════════════
// ENTRY POINT
// ═══════════════════════════════════════════════════════════════════════════════

void main(List<String> args) {
  if (args.isEmpty || args[0] == '--help' || args[0] == '-h') {
    _printUsage();
    exit(0);
  }

  final mode = args[0].toLowerCase();

  if (mode == 'analyze') {
    if (args.length < 2) {
      print('❌ analyze mode requires a feature name.');
      _printUsage();
      exit(1);
    }
    _runAnalyzer(args[1], autoFix: args.contains('--fix'));
  } else if (mode == 'extract') {
    if (args.length < 2) {
      print('❌ extract mode requires a path to the screen file.');
      _printUsage();
      exit(1);
    }
    _runExtractor(args[1]);
  } else {
    print('❌ Unknown mode: "$mode". Use `analyze` or `extract`.');
    _printUsage();
    exit(1);
  }
}

void _printUsage() {
  print('''
📦 UI Toolkit — Usage:

  Analyze a feature for design-guide violations:
    dart run lib/core/tools/mcp/ui_toolkit.dart analyze <feature_name> [--fix]

  Extract @widget_ex annotated widgets from a screen file:
    dart run lib/core/tools/mcp/ui_toolkit.dart extract <path_to_screen_file>
''');
}

// ═══════════════════════════════════════════════════════════════════════════════
// MODE 1 — ANALYZER & AUTO-FIXER
// ═══════════════════════════════════════════════════════════════════════════════

void _runAnalyzer(String featureName, {required bool autoFix}) {
  final uiDir = Directory('lib/features/screens/$featureName/ui');

  if (!uiDir.existsSync()) {
    print('❌ UI directory not found: ${uiDir.path}');
    exit(1);
  }

  print('🔍 Analyzing UI for feature: $featureName (auto-fix: $autoFix)\n');

  final files = uiDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  int totalViolations = 0;
  int fixedCount = 0;

  for (final file in files) {
    String content = file.readAsStringSync();
    final originalContent = content;
    final sep = Platform.pathSeparator;
    final isMainScreen = file.path.endsWith('_screen.dart');
    final isWidget = file.path.contains('${sep}widgets$sep');

    final List<String> reports = [];

    // ── Rule 1: SizedBox spacing → extensions ────────────────────────────────
    final vertRx = RegExp(r'SizedBox\s*\(\s*height\s*:\s*([0-9.]+)\s*\)');
    if (vertRx.hasMatch(content)) {
      final n = vertRx.allMatches(content).length;
      if (autoFix) {
        content = content.replaceAllMapped(vertRx, (m) => '${m.group(1)}.verticalSpace');
        reports.add('🔧 Fixed $n × SizedBox(height) → .verticalSpace');
        fixedCount += n;
      } else {
        reports.add('⚠️  $n × SizedBox(height) — use .verticalSpace');
        totalViolations += n;
      }
    }

    final horizRx = RegExp(r'SizedBox\s*\(\s*width\s*:\s*([0-9.]+)\s*\)');
    if (horizRx.hasMatch(content)) {
      final n = horizRx.allMatches(content).length;
      if (autoFix) {
        content = content.replaceAllMapped(horizRx, (m) => '${m.group(1)}.horizontalSpace');
        reports.add('🔧 Fixed $n × SizedBox(width) → .horizontalSpace');
        fixedCount += n;
      } else {
        reports.add('⚠️  $n × SizedBox(width) — use .horizontalSpace');
        totalViolations += n;
      }
    }

    // ── Rule 2: Semantics must wrap every widget call in the main screen ──────
    // (Semantics lives in screen, not inside widget files — checked on screen)
    if (isMainScreen) {
      // Find extracted widget calls (PascalCase ending in ()) that lack Semantics wrapper
      final widgetCallRx = RegExp(r'(?<!Semantics\s*\(\s*label\s*:.*\s*child\s*:\s*)const\s+([A-Z][a-zA-Z0-9]+)\(\)');
      final unWrapped = widgetCallRx.allMatches(content)
          .where((m) {
            // Check if the call is already inside a Semantics block
            final before = content.substring(0, m.start);
            // naive check: last 200 chars before this call shouldn't have unclosed Semantics
            final window = before.length > 200 ? before.substring(before.length - 200) : before;
            return !window.contains('Semantics(');
          })
          .map((m) => m.group(1))
          .toSet()
          .toList();

      if (unWrapped.isNotEmpty) {
        reports.add('⚠️  Widget call(s) missing Semantics wrapper in screen: ${unWrapped.map((w) => '`$w()`').join(', ')}');
        reports.add('   💡 Add @widget_ex annotations and run `extract` to fix, or wrap manually.');
        totalViolations += unWrapped.length;
      }
    }

    // ── Rule 3: Hardcoded colors ──────────────────────────────────────────────
    final colorsRx = RegExp(r'(Colors\.[a-zA-Z]+|Color\(0x[0-9a-fA-F]+\))');
    if (colorsRx.hasMatch(content)) {
      final n = colorsRx.allMatches(content).length;
      reports.add('⚠️  $n hardcoded Color value(s). Use AppColors instead.');
      totalViolations += n;
    }

    // ── Rule 4: Inline TextStyle ──────────────────────────────────────────────
    final textStyleRx = RegExp(r'TextStyle\s*\(');
    if (textStyleRx.hasMatch(content)) {
      final n = textStyleRx.allMatches(content).length;
      reports.add('⚠️  $n inline TextStyle(s). Use AppTextStyles.xxx.copyWith() instead.');
      totalViolations += n;
    }

    // ── Rule 5: Scaffold body must not be an inline complex widget ────────────
    if (isMainScreen) {
      final bodyRx = RegExp(r'body\s*:\s*(Column|Row|Container|ListView|Stack|Padding|Expanded)\s*\(');
      if (bodyRx.hasMatch(content)) {
        reports.add('🛑 Scaffold body is inline. Annotate with `/// @widget_ex ==> <name>` and run extract.');
        totalViolations++;
      }
      final appBarRx = RegExp(r'appBar\s*:\s*(AppBar|Container)\s*\(');
      if (appBarRx.hasMatch(content)) {
        reports.add('🛑 Scaffold appBar is inline. Annotate with `/// @widget_ex ==> <name>` and run extract.');
        totalViolations++;
      }
    }

    // ── Rule 6: Widget files must NOT return Semantics as outermost wrapper ───
    // (screen owns the outermost Semantics; inner Semantics on children are OK)
    if (isWidget) {
      final returnSemanticsRx = RegExp(r'return\s+Semantics\s*\(');
      if (returnSemanticsRx.hasMatch(content)) {
        reports.add('⚠️  Widget file returns Semantics as root. Move it to the call-site in the main screen.');
        totalViolations++;
      }
    }

    if (autoFix && content != originalContent) {
      file.writeAsStringSync(content);
    }

    if (reports.isNotEmpty) {
      print('📄 ${file.uri.pathSegments.last}:');
      for (final r in reports) print('   $r');
      print('');
    }
  }

  print('─' * 50);
  print('📊 Analysis complete for: $featureName');
  if (autoFix) print('✅ Auto-fixed: $fixedCount issue(s)');
  print('⚠️  Remaining violations: $totalViolations');
  if (totalViolations > 0) {
    print('\n💡 For extraction violations:');
    print('   1. Annotate the widget: `/// @widget_ex ==> my widget name`');
    print('   2. Run: dart run lib/core/tools/mcp/ui_toolkit.dart extract <screen_path>');
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// MODE 2 — WIDGET EXTRACTOR
// ═══════════════════════════════════════════════════════════════════════════════

void _runExtractor(String screenFilePath) {
  final normalPath = screenFilePath.replaceAll('\\', '/');
  final screenFile = File(normalPath);

  if (!screenFile.existsSync()) {
    print('❌ File not found: $normalPath');
    exit(1);
  }

  final screenDir = screenFile.parent.path.replaceAll('\\', '/');
  final widgetsDir = Directory('$screenDir/widgets');
  if (!widgetsDir.existsSync()) widgetsDir.createSync(recursive: true);

  final screenFileName = screenFile.uri.pathSegments.last;
  final raw = screenFile.readAsStringSync();
  final lines = raw.split('\n');

  final annotationRx = RegExp(r'///\s*@widget_ex\s*==>\s*(.+)');
  final List<_Extraction> extractions = [];

  // ── Pass 1: collect annotations ─────────────────────────────────────────────
  for (int i = 0; i < lines.length; i++) {
    final match = annotationRx.firstMatch(lines[i].trim());
    if (match == null) continue;

    final rawName     = match.group(1)!.trim();
    final pascalName  = _toPascal(rawName);
    final snakeName   = _toSnake(rawName);

    // Next non-empty line is the widget start
    int widgetLineIdx = i + 1;
    while (widgetLineIdx < lines.length && lines[widgetLineIdx].trim().isEmpty) {
      widgetLineIdx++;
    }
    if (widgetLineIdx >= lines.length) continue;

    final widgetLine   = lines[widgetLineIdx];
    final indentMatch  = RegExp(r'^(\s*)').firstMatch(widgetLine);
    final indent       = indentMatch?.group(1) ?? '';

    final srcFromWidget = lines.sublist(widgetLineIdx).join('\n');
    final widgetCode    = _extractBalanced(srcFromWidget, 0);
    final cleanCode     = widgetCode.endsWith(',')
        ? widgetCode.substring(0, widgetCode.length - 1)
        : widgetCode;

    extractions.add(_Extraction(
      annotationLineIdx: i,
      widgetLineIdx: widgetLineIdx,
      widgetCode: widgetCode,
      cleanWidgetCode: cleanCode,
      indent: indent,
      pascalName: pascalName,
      snakeName: snakeName,
    ));
  }

  if (extractions.isEmpty) {
    print('ℹ️  No @widget_ex annotations found in $screenFileName');
    return;
  }

  print('🔍 Found ${extractions.length} widget(s) to extract from $screenFileName\n');

  // ── Pass 2: calculate widget end lines ──────────────────────────────────────
  for (final ext in extractions) {
    int depth = 0;
    bool started = false;
    int endLine = ext.widgetLineIdx;

    for (int l = ext.widgetLineIdx; l < lines.length; l++) {
      for (final ch in lines[l].split('')) {
        if (ch == '(') { depth++; started = true; }
        if (ch == ')') depth--;
      }
      if (started && depth == 0) { endLine = l; break; }
    }
    ext.widgetEndLineIdx = endLine;
  }

  // ── Pass 3: write widget part files (NO Semantics inside) ───────────────────
  for (final ext in extractions) {
    final widgetFilePath = '${widgetsDir.path}/${ext.snakeName}.dart'.replaceAll('\\', '/');

    final widgetSrc = '''part of '../$screenFileName';

/// Extracted widget: ${ext.pascalName}
/// Semantics is applied at the call-site in $screenFileName
class ${ext.pascalName} extends StatelessWidget {
  const ${ext.pascalName}({super.key});

  @override
  Widget build(BuildContext context) {
    return ${ext.cleanWidgetCode};
  }
}
''';

    File(widgetFilePath).writeAsStringSync(widgetSrc);
    print('✅ Created: widgets/${ext.snakeName}.dart  →  class ${ext.pascalName}');
  }

  // ── Pass 4: rewrite screen file ─────────────────────────────────────────────
  final newLines = List<String>.from(lines);
  final partDirectives = extractions
      .map((e) => "part 'widgets/${e.snakeName}.dart';")
      .toList();

  // Replace annotation + widget block (reversed so indices stay valid)
  for (final ext in extractions.reversed) {
    // The replacement in the screen:
    //   Semantics(label: 'WidgetName', child: const WidgetName()),
    final replacement =
        '${ext.indent}Semantics(\n'
        '${ext.indent}  label: \'${ext.pascalName}\',\n'
        '${ext.indent}  child: const ${ext.pascalName}(),\n'
        '${ext.indent}),';

    newLines.removeRange(ext.annotationLineIdx, ext.widgetEndLineIdx + 1);
    newLines.insert(ext.annotationLineIdx, replacement);
  }

  // Remove old widget imports if any
  newLines.removeWhere((l) =>
      l.contains("import 'widgets/") && l.trim().startsWith("import '"));

  // Find last `part '...'` line to inject after it
  int insertPartAt = -1;
  for (int i = 0; i < newLines.length; i++) {
    if (newLines[i].trim().startsWith("part '")) insertPartAt = i;
  }
  if (insertPartAt == -1) {
    // fallback: before first @/class
    for (int i = 0; i < newLines.length; i++) {
      if (newLines[i].trim().startsWith('@') ||
          newLines[i].trim().startsWith('class ')) {
        insertPartAt = i - 1;
        break;
      }
    }
  }

  for (final directive in partDirectives.reversed) {
    if (!newLines.contains(directive)) {
      newLines.insert(insertPartAt + 1, directive);
    }
  }

  screenFile.writeAsStringSync(newLines.join('\n'));

  print('\n✏️  Rewrote: $normalPath');
  print('   → ${extractions.length} widget(s) extracted');
  print('   → ${partDirectives.length} part directive(s) injected');
  print('   → Semantics wrapper placed at CALL-SITE in screen (not inside widget files)');
  print('\n📋 Extraction map:');
  for (final ext in extractions) {
    print('   • ${ext.pascalName}  →  widgets/${ext.snakeName}.dart');
  }
  print('\n💡 Run analyze to confirm no remaining violations:');
  final featureRx = RegExp(r'lib/features/screens/([^/]+)/');
  final fmatch = featureRx.firstMatch(normalPath);
  final fname = fmatch?.group(1) ?? '<feature>';
  print('   dart run lib/core/tools/mcp/ui_toolkit.dart analyze $fname');
}
