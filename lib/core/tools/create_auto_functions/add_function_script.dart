import 'dart:convert';
import 'dart:io';
import '../create_auto_files/path_constants.dart';
import 'components/function_script_helpers.dart';
import 'components/function_constants_added.dart';
import 'components/function_repo_added.dart';
import 'components/function_service_added.dart';
import 'components/function_controller_added.dart';

// ─── Entry Point ─────────────────────────────────────────────────────────────
//
// Usage:
//   dart run lib/core/tools/create_auto_functions/add_function_script.dart \
//       [<featureName> <functionName> <returnType> <paramType>]
//
// ─────────────────────────────────────────────────────────────────────────────

Future<void> main(List<dynamic> args) async {
  String featureName = '';
  String functionName = '';
  String returnType = '';
  String paramType = '';

  if (args.length >= 4) {
    featureName  = args[0].toString();
    functionName = args[1].toString();
    returnType   = args[2].toString();
    paramType    = args[3].toString();
  } else {
    print('⚠️ Missing parameters.');
    print('Please enter all 4 parameters separated by a space:');
    print('<featureName> <functionName> <returnType> <paramType>');
    print('Example: projects getProjects AllProjectsRes NoParameter');
    stdout.write('> ');

    final input = stdin.readLineSync(encoding: utf8)?.trim() ?? '';
    final parts = input.split(RegExp(r'\s+'));

    if (parts.length >= 4) {
      featureName  = parts[0];
      functionName = parts[1];
      returnType   = parts[2];
      paramType    = parts[3];
    }
  }

  if (featureName.isEmpty || functionName.isEmpty || returnType.isEmpty || paramType.isEmpty) {
    print('❌ Error: All parameters are required.');
    exit(1);
  }

  PathConstants().setData(featureName);
  final p = PathConstants();

  final baseFeature = 'lib/features/screens/$featureName';
  final repoPath    = '$baseFeature/data/repo/remote/${featureName}_repo.dart';
  final svcPath     = '$baseFeature/service/${p.serviceFileName()}';
  final cubitPath   = '$baseFeature/controller/${p.cubitFileName()}';
  final statePath   = '$baseFeature/controller/${p.stateFileName()}';

  final requiredFiles = [repoPath, svcPath, cubitPath, statePath];
  for (final path in requiredFiles) {
    if (!File(path).existsSync()) {
      stderr.writeln('❌ File not found: $path');
      exit(1);
    }
  }

  print('📝 Adding "$functionName" to all layers of "$featureName"...');

  // 1. AppConstant & AppAPI
  final keyCodeName = '${functionName}KeyCode';
  final cacheKeyName = '${functionName}KeyCash';
  await registerConstant(cacheKeyName, '${featureName}_${functionName}_cache');
  await registerIntConstant(keyCodeName, '${featureName}_$functionName'.hashCode % 10000);
  await registerApiEndpoint(functionName);

  // 2. Repo
  await addFunctionToRepo(
    featureName: featureName,
    functionName: functionName,
    returnType: returnType,
    paramType: paramType,
    repoPath: repoPath,
  );

  // 3. Service
  await addFunctionToService(
    featureName: featureName,
    functionName: functionName,
    returnType: returnType,
    paramType: paramType,
    svcPath: svcPath,
  );

  // 4. Controller (Cubit and State)
  await addFunctionToController(
    featureName: featureName,
    functionName: functionName,
    returnType: returnType,
    paramType: paramType,
    cubitPath: cubitPath,
    statePath: statePath,
  );

  print('✅ "$functionName" successfully added to "$featureName"');
}


