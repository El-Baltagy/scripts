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

  final baseFeature   = 'lib/features/screens/$featureName';

  // Concrete remote repo  →  data/repo/remote/home_remote_repo.dart
  final repoPath      = '$baseFeature/data/repo/${p.remoteRepoFileName()}';
  // Abstract base repo    →  data/repo/base_home_repo.dart
  final baseRepoPath  = '$baseFeature/data/repo/${p.baseRepoFileName()}';

  // Concrete remote service  →  service/home_remote_service.dart
  final svcPath       = '$baseFeature/service/${p.serviceFileName()}';
  // Abstract base service   →  service/base_home_service.dart
  final baseSvcPath   = '$baseFeature/service/${p.baseServiceFileName()}';

  final cubitPath     = '$baseFeature/controller/${p.cubitFileName()}';
  final statePath     = '$baseFeature/controller/${p.stateFileName()}';

  final requiredFiles = [repoPath, baseRepoPath, svcPath, baseSvcPath, cubitPath, statePath];
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

  // 2. Repo  (abstract signature + concrete implementation)
  await addFunctionToRepo(
    featureName: featureName,
    functionName: functionName,
    returnType: returnType,
    paramType: paramType,
    baseRepoPath: baseRepoPath,
    repoPath: repoPath,
  );

  // 3. Service  (abstract signature + concrete implementation)
  await addFunctionToService(
    featureName: featureName,
    functionName: functionName,
    returnType: returnType,
    paramType: paramType,
    baseSvcPath: baseSvcPath,
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


