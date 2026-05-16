import 'dart:io';
import '../utils_spinner.dart';

import '1-pubspec_patcher.dart' as patcher;
import '2-smart_const_fixer.dart' as constfixer;
import '3-organize_reformat_Code.dart' as formatter;
import '4-find_to_do_commits.dart' as getToDo;
import '5-code_stream_analyzer.dart' as analyzer;
import '6-project_health_analyzer.dart';

Future<void> main(List<String> args) async {
  final withFixes = args.contains('--fix');
  final spinner = Spinner('🧰 Running Project Maintenance...');
  spinner.start();

  await patcher.runPubspecPatcher();
  await constfixer.runSmartConstFixer();
  await formatter.reformatCode();
  await getToDo.getToDoCommits();
  await analyzer.runCodeStreamAnalyzer(autoFix: withFixes);

  // Project Health Analysis (Circular imports & Unused files)
  final healthAnalyzer = ProjectHealthAnalyzer(Directory.current.path);
  await healthAnalyzer.run(autoFix: withFixes);

  spinner.stop('✅ Maintenance completed successfully!');
}
