import 'dart:io';

/// UI Code Analyzer & Auto-Fixer
/// 
/// This script checks a feature's UI code against the AI Design Guide.
/// It can auto-fix simple styling violations (SizedBox spacing) and reports
/// structural violations (missing Semantics, hardcoded colors, large Scaffolds)
/// so the AI or Developer can extract and fix them.
///
/// Usage:
///   dart run lib/core/tools/mcp/ui_code_analyzer_and_fixer.dart <feature_name> [--fix]

void main(List<String> args) {
  if (args.isEmpty) {
    print('❌ Usage: dart run lib/core/tools/mcp/ui_code_analyzer_and_fixer.dart <feature_name> [--fix]');
    exit(1);
  }

  final featureName = args[0];
  final autoFix = args.contains('--fix');
  final uiDir = Directory('lib/features/screens/$featureName/ui');

  if (!uiDir.existsSync()) {
    print('❌ UI directory not found: ${uiDir.path}');
    exit(1);
  }

  print('🔍 Analyzing UI for feature: $featureName (Auto-fix: $autoFix)\n');

  final files = uiDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart')).toList();

  int totalViolations = 0;
  int fixedCount = 0;

  for (final file in files) {
    String content = file.readAsStringSync();
    String originalContent = content;
    final isMainScreen = file.path.endsWith('_screen.dart');
    final isWidget = file.path.contains('${Platform.pathSeparator}widgets${Platform.pathSeparator}');
    
    List<String> fileReports = [];

    // 1. Spacing Rule: SizedBox(height: X) -> X.verticalSpace
    final verticalSpaceRx = RegExp(r'SizedBox\s*\(\s*height\s*:\s*([0-9.]+)\s*\)');
    if (verticalSpaceRx.hasMatch(content)) {
      final matches = verticalSpaceRx.allMatches(content).length;
      if (autoFix) {
        content = content.replaceAllMapped(verticalSpaceRx, (m) => '${m.group(1)}.verticalSpace');
        fileReports.add('🔧 Auto-fixed $matches instance(s) of SizedBox(height) to .verticalSpace');
        fixedCount += matches;
      } else {
        fileReports.add('⚠️ Found $matches instance(s) of SizedBox(height). Use .verticalSpace instead.');
        totalViolations += matches;
      }
    }

    // Spacing Rule: SizedBox(width: X) -> X.horizontalSpace
    final horizontalSpaceRx = RegExp(r'SizedBox\s*\(\s*width\s*:\s*([0-9.]+)\s*\)');
    if (horizontalSpaceRx.hasMatch(content)) {
      final matches = horizontalSpaceRx.allMatches(content).length;
      if (autoFix) {
        content = content.replaceAllMapped(horizontalSpaceRx, (m) => '${m.group(1)}.horizontalSpace');
        fileReports.add('🔧 Auto-fixed $matches instance(s) of SizedBox(width) to .horizontalSpace');
        fixedCount += matches;
      } else {
        fileReports.add('⚠️ Found $matches instance(s) of SizedBox(width). Use .horizontalSpace instead.');
        totalViolations += matches;
      }
    }

    // 2. Semantics Rule: Every widget must have Semantics
    if (isWidget) {
      if (!content.contains('Semantics(')) {
        fileReports.add('🛑 Missing Semantics: Outermost wrapper must be Semantics(label: "..."). Extraction incomplete.');
        totalViolations++;
      }
    }

    // 3. Hardcoded Colors Rule (Warnings only)
    final colorsRx = RegExp(r'(Colors\.[a-z]+|Color\(0x[0-9a-fA-F]+\))');
    if (colorsRx.hasMatch(content)) {
      final matches = colorsRx.allMatches(content).length;
      fileReports.add('⚠️ Found $matches hardcoded Color(s). Must use AppColors.');
      totalViolations += matches;
    }

    // 4. Hardcoded TextStyles Rule (Warnings only)
    final textStyleRx = RegExp(r'TextStyle\s*\(');
    if (textStyleRx.hasMatch(content)) {
      final matches = textStyleRx.allMatches(content).length;
      fileReports.add('⚠️ Found $matches inline TextStyle(s). Must use AppTextStyles with .copyWith().');
      totalViolations += matches;
    }

    // 5. Screen Component Extraction Rule
    if (isMainScreen) {
      // Check if Scaffold body is not a single custom widget (very basic check)
      final scaffoldBodyRx = RegExp(r'body\s*:\s*(Column|Row|Container|ListView|Stack|Padding|Expanded)\s*\(');
      if (scaffoldBodyRx.hasMatch(content)) {
        fileReports.add('🛑 Architecture Violation: Scaffold body contains inline complex widgets (e.g. Column/Container). MUST extract to `widgets/` folder.');
        totalViolations++;
      }
      
      final scaffoldAppBarRx = RegExp(r'appBar\s*:\s*(AppBar|Container)\s*\(');
      if (scaffoldAppBarRx.hasMatch(content)) {
        fileReports.add('🛑 Architecture Violation: Scaffold appBar is built inline. MUST extract to `widgets/` folder.');
        totalViolations++;
      }
    }

    if (autoFix && content != originalContent) {
      file.writeAsStringSync(content);
    }

    if (fileReports.isNotEmpty) {
      print('📄 ${file.uri.pathSegments.last}:');
      for (final report in fileReports) {
        print('   $report');
      }
      print('');
    }
  }

  print('--------------------------------------------------');
  print('📊 Analysis Complete for $featureName UI');
  if (autoFix) {
    print('✅ Auto-fixed issues: $fixedCount');
  }
  print('⚠️ Outstanding violations to extract/fix: $totalViolations');
  
  if (totalViolations > 0) {
    print('\n💡 To resolve extraction violations, create new files in `widgets/`,');
    print('   wrap them in `Semantics(label: "...")`, and pass any required Cubit states.');
  }
}
