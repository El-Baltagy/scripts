// ignore_for_file: avoid_print
import 'dart:io';

/// Widget Extractor
///
/// Reads a screen dart file, finds every `/// @widget_ex ==> <WidgetName>` annotation,
/// extracts the annotated widget into a separate file inside the `widgets/` folder,
/// wraps it with `Semantics`, and replaces the original inline code with
/// the new extracted class reference.
///
/// Uses `part` / `part of` so no additional imports are needed in the main screen.
///
/// Usage:
///   dart run lib/core/tools/mcp/widget_extractor.dart <path_to_screen_file>
///
/// Example:
///   dart run lib/core/tools/mcp/widget_extractor.dart \
///     lib/features/screens/main_screen/ui/main_screen/main_screen_screen.dart

// ─── helpers ──────────────────────────────────────────────────────────────────

String toPascal(String s) => s
    .split(RegExp(r'[\s_]+'))
    .where((w) => w.isNotEmpty)
    .map((w) => '${w[0].toUpperCase()}${w.substring(1)}')
    .join('');

String toSnake(String s) => s
    .replaceAllMapped(RegExp(r'[A-Z]'), (m) => '_${m.group(0)!.toLowerCase()}')
    .replaceFirst(RegExp(r'^_'), '')
    .replaceAll(RegExp(r'\s+'), '_')
    .toLowerCase();

/// Extract a balanced bracket expression starting at [startIndex] in [src].
/// Returns the full substring from the first opening paren/bracket to its match.
String _extractBalanced(String src, int startIndex) {
  // Find the first opening bracket at or after startIndex
  final openIdx = src.indexOf('(', startIndex);
  if (openIdx == -1) return src.substring(startIndex).trim();

  int depth = 0;
  int end = openIdx;

  for (int i = openIdx; i < src.length; i++) {
    if (src[i] == '(') depth++;
    if (src[i] == ')') {
      depth--;
      if (depth == 0) {
        end = i;
        break;
      }
    }
  }

  return src.substring(openIdx - _widgetNameBefore(src, openIdx).length, end + 1).trim();
}

/// Walk backwards from [openIdx] to grab the widget/class name before the `(`.
String _widgetNameBefore(String src, int openIdx) {
  if (openIdx == 0) return '';
  int i = openIdx - 1;
  // skip whitespace
  while (i >= 0 && src[i] == ' ') i--;
  // collect identifier chars
  int end = i;
  while (i >= 0 && (RegExp(r'[a-zA-Z0-9_.]').hasMatch(src[i]))) i--;
  return src.substring(i + 1, end + 1);
}

// ─── main ─────────────────────────────────────────────────────────────────────

void main(List<String> args) {
  if (args.isEmpty) {
    print('❌ Usage: dart run lib/core/tools/mcp/widget_extractor.dart <path_to_screen_file>');
    exit(1);
  }

  final screenFilePath = args[0].replaceAll('\\', '/');
  final screenFile = File(screenFilePath);

  if (!screenFile.existsSync()) {
    print('❌ File not found: $screenFilePath');
    exit(1);
  }

  // Derive the widgets/ directory and the screen part-file relative reference
  final screenDir = screenFile.parent.path.replaceAll('\\', '/');
  final widgetsDir = Directory('$screenDir/widgets');
  if (!widgetsDir.existsSync()) {
    widgetsDir.createSync(recursive: true);
  }

  // The screen filename without extension — used for `part of` directive
  final screenFileName = screenFile.uri.pathSegments.last; // e.g. main_screen_screen.dart

  final raw = screenFile.readAsStringSync();

  // ── find package name ──────────────────────────────────────────────────────
  // Derive package name from any existing package import
  final pkgRx = RegExp(r"import 'package:([^/]+)/");
  final pkgMatch = pkgRx.firstMatch(raw);
  final packageName = pkgMatch?.group(1) ?? 'app';

  // Derive the feature name from path (lib/features/screens/<feature>/...)
  final featureRx = RegExp(r'lib/features/screens/([^/]+)/');
  final featureMatch = featureRx.firstMatch(screenFilePath);
  final featureName = featureMatch?.group(1) ?? 'feature';

  // ── parse lines ───────────────────────────────────────────────────────────
  final lines = raw.split('\n');

  final annotationRx = RegExp(r'///\s*@widget_ex\s*==>\s*(.+)');

  List<_Extraction> extractions = [];

  for (int i = 0; i < lines.length; i++) {
    final match = annotationRx.firstMatch(lines[i].trim());
    if (match == null) continue;

    final rawWidgetName = match.group(1)!.trim();
    final pascalName = toPascal(rawWidgetName);   // e.g. SizedBox / ColumnBehaviour
    final snakeName = toSnake(rawWidgetName);       // e.g. sized_box / column_behaviour

    // Next non-empty line is the widget start
    int widgetLineIdx = i + 1;
    while (widgetLineIdx < lines.length && lines[widgetLineIdx].trim().isEmpty) {
      widgetLineIdx++;
    }
    if (widgetLineIdx >= lines.length) continue;

    // Get indentation from the widget line
    final widgetLine = lines[widgetLineIdx];
    final indentMatch = RegExp(r'^(\s*)').firstMatch(widgetLine);
    final indent = indentMatch?.group(1) ?? '';

    // Reconstruct the full source from widgetLineIdx to the end so bracket counting works
    final srcFromWidget = lines.sublist(widgetLineIdx).join('\n');
    final widgetCode = _extractBalanced(srcFromWidget, 0);

    // Trailing comma: strip if present at end of extracted code (it's now a class body)
    final cleanWidgetCode = widgetCode.endsWith(',')
        ? widgetCode.substring(0, widgetCode.length - 1)
        : widgetCode;

    extractions.add(_Extraction(
      annotationLineIdx: i,
      widgetLineIdx: widgetLineIdx,
      widgetCode: widgetCode,
      cleanWidgetCode: cleanWidgetCode,
      indent: indent,
      pascalName: pascalName,
      snakeName: snakeName,
    ));
  }

  if (extractions.isEmpty) {
    print('ℹ️  No @widget_ex annotations found in $screenFilePath');
    return;
  }

  print('🔍 Found ${extractions.length} widget(s) to extract from $screenFileName\n');

  // ── generate widget files ──────────────────────────────────────────────────
  for (final ext in extractions) {
    final widgetFilePath = '${widgetsDir.path}/${ext.snakeName}.dart'.replaceAll('\\', '/');
    final widgetFile = File(widgetFilePath);

    final widgetSrc = '''part of '../$screenFileName';

class ${ext.pascalName} extends StatelessWidget {
  const ${ext.pascalName}({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${ext.pascalName}',
      child: ${ext.cleanWidgetCode},
    );
  }
}
''';

    widgetFile.writeAsStringSync(widgetSrc);
    print('✅ Created widget: widgets/${ext.snakeName}.dart  (class: ${ext.pascalName})');
  }

  // ── rewrite the screen file ────────────────────────────────────────────────
  // We'll rebuild the file line by line.
  // Strategy:
  //   - Collect line ranges to DELETE (annotation + widget block).
  //   - Collect lines to INSERT (part directive + class reference).

  // Build a set of line-index ranges to remove (annotation + widget lines)
  // and replacement content (the class call).
  // We process in reverse order so indices stay valid.

  // First pass: calculate which lines each extraction occupies
  for (final ext in extractions) {
    // Count how many lines the widget body spans
    int depth = 0;
    bool started = false;
    int endLine = ext.widgetLineIdx;

    for (int l = ext.widgetLineIdx; l < lines.length; l++) {
      for (final ch in lines[l].split('')) {
        if (ch == '(') { depth++; started = true; }
        if (ch == ')') depth--;
      }
      if (started && depth == 0) {
        endLine = l;
        break;
      }
    }
    ext.widgetEndLineIdx = endLine;
  }

  // Build new lines list (in reverse to preserve indices)
  final newLines = List<String>.from(lines);

  // collect part directives to add (deduplicated)
  final partDirectives = extractions.map((e) => "part 'widgets/${e.snakeName}.dart';").toList();

  // Replace each extraction range in reverse order
  for (final ext in extractions.reversed) {
    // Replace annotation line + widget lines with the class reference call
    final replacement = '${ext.indent}const ${ext.pascalName}(),';
    newLines.removeRange(ext.annotationLineIdx, ext.widgetEndLineIdx + 1);
    newLines.insert(ext.annotationLineIdx, replacement);
  }

  // Now inject `part` directives right after the last existing `part '...'` line
  // or before the first class declaration if none found.
  int insertPartAt = -1;
  for (int i = 0; i < newLines.length; i++) {
    final trimmed = newLines[i].trim();
    if (trimmed.startsWith("part '")) {
      insertPartAt = i;
    }
  }

  // Remove any import lines for widgets (in case previously added as import)
  newLines.removeWhere((l) => l.contains("import 'widgets/") && l.trim().startsWith("import '"));

  // Insert part directives (deduplicated) right after last `part '...'` line
  if (insertPartAt == -1) {
    // No existing part, insert before first class/annotation
    for (int i = 0; i < newLines.length; i++) {
      if (newLines[i].trim().startsWith('@') || newLines[i].trim().startsWith('class ')) {
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

  final newContent = newLines.join('\n');
  screenFile.writeAsStringSync(newContent);

  print('\n✏️  Rewrote: $screenFilePath');
  print('   → Replaced ${extractions.length} inline widget(s) with extracted class calls');
  print('   → Added ${partDirectives.length} part directive(s)');

  // ── run analyzer to confirm ────────────────────────────────────────────────
  print('\n📋 Summary:');
  for (final ext in extractions) {
    print('   • ${ext.pascalName}  →  widgets/${ext.snakeName}.dart');
  }
}

// ─── model ────────────────────────────────────────────────────────────────────

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
