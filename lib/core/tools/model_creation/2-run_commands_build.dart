import 'dart:io';
import 'dart:convert';
import '../utils_spinner.dart';

Future<void> runCommandBuild(List<String> args, Spinner spinner) async {
  if (args.isEmpty) {
    spinner.stop('Usage: dart run tool/generate_freezed_from_map.dart <input.json> <RootClassName> [--existing=key=import:Type,...]');
    exit(1);
  }
  final className =  args[0] ;
  final screenName =  args[1] ;
  final modelFolderPath =  "lib/features/screens/$screenName/data/model" ;
  final String fileName = className .
  replaceAllMapped(RegExp(r'(?<!^)([A-Z])'), (Match m) => '_${m.group(0)}') .toLowerCase();
  
  final outDir = Directory('$modelFolderPath/$fileName');
  final outFile = File('${outDir.path}/$fileName.dart');

  if (!await outFile.exists()) {
    spinner.stop('Error: File ${outFile.path} does not exist! Please run 1-create_entity.dart first.');
    exit(1);
  }
//SubCatogeriesData
  if (args.contains('--no-build')) {
    spinner.stop('Model file created. Skipping build_runner as requested.');
    return;
  }

  stdout.write('Do you want to continue [Y/N]: ');
  final input = stdin.readLineSync(encoding: utf8)?.trim().toLowerCase() ?? '';

  if (input.isEmpty || input == 'n' || input == 'no') {
    spinner.stop('Aborted by user.');
    exit(0);
  }

  if (input == 'y' || input == 'yes') {

    stdout.write('Do you want generate only for this model [Y/N]: ');
    final input = stdin.readLineSync(encoding: utf8)?.trim().toLowerCase() ?? '';
    List<String>additionalArg=[];
    if ( input.toLowerCase() == 'y' || input.toLowerCase() == 'yes') {
      final String  relativePath = '${outDir.path}/$fileName';
      additionalArg=[
        '--build-filter=$relativePath.g.dart',
        '--build-filter=$relativePath.freezed.dart',

      ];
    }



    print('Running build_runner...');
    final process = await Process.start(
        'flutter',
        ['pub', 'run', 'build_runner', 'build','--delete-conflicting-outputs',...additionalArg],
        runInShell: true);
    process.stdout.transform(const SystemEncoding().decoder).listen(print);
    process.stderr.transform(const SystemEncoding().decoder).listen(print);

    await process.exitCode;

    spinner.stop();
  }else{
    // If user typed something else, treat as abort
    spinner.stop('Unrecognized input. Aborted.');
    exit(0);
  }
}

/// Allows running this script directly from the terminal for an existing class
/// Example: dart run lib/core/tools/model_creation/2-run_commands_build.dart RootClassName ScreenName
Future<void> main(List<String> args) async {
  final spinner = Spinner('⚙️ Running Build Runner...');
  spinner.start();
  
  if (args.length < 2) {
    spinner.stop('Usage: dart run 2-run_commands_build.dart <ClassName> <ScreenName>');
    exit(1);
  }
  
  // We don't need to pass code here anymore, just args and spinner
  await runCommandBuild(args, spinner);
}