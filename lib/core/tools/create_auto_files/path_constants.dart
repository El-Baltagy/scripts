import 'dart:io';

class PathConstants {
  PathConstants._();

  static final PathConstants _instance = PathConstants._();

  factory PathConstants() => _instance;
  late String name;


  setData(String name) {
    this.name = name;
  }

  String get projectName {
    final pubspec = File('pubspec.yaml');
    if (pubspec.existsSync()) {
      final content = pubspec.readAsStringSync();
      final match = RegExp(r'^name:\s*(.+)$', multiLine: true).firstMatch(content);
      if (match != null) {
        return match.group(1)!.trim();
      }
    }
    return 'tahseen'; // fallback
  }

  /// Converts a string like 'bottom_nav_screen' to PascalCase 'BottomNavScreen'
  String toPascalCase(String input, {bool lowerCaseFirstChar = false}) {
    // 1. Split by underscore, capitalize each word, and join them
    String x = input.split('_').map((word) {
      if (word.isEmpty) return '';
      // Use toUpperCase() for the first letter of each word
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join();
    // 2. If lowerCaseFirstChar is true, it becomes camelCase
    if (lowerCaseFirstChar && x.isNotEmpty) {
      x = x[0].toLowerCase() + x.substring(1);
    }

    return x;
  }
  String tolowerCasTheFirstCharachter(String word) {
    if (word.isEmpty) return '_x';
    return word[0].toLowerCase() + word.substring(1);
  }

  String basePath() => "lib/features/screens/$name";

  String folderPath(String folder) => '${basePath()}/$folder';

  ///..............repo.........///

  /// Concrete remote repo — e.g. HomeRemoteRepo
  String repoName() => "${toPascalCase(name)}RemoteRepo";

  String remoteRepoFileName() => '${name}_remote_repo.dart';

  /// Abstract base repo — e.g. BaseHomeRepo
  String baseRepoName() => "Base${toPascalCase(name)}Repo";

  String baseRepoFileName() => 'base_${name}_repo.dart';

  String modelNotifierDataFileName() => '${name}_notifier_data.dart';

  String modelNotifierDataClassName() => '${toPascalCase(name)}NotifierData';

  /// Remote repo lives in data/repo/remote/
  String repoPath() => folderPath('data/repo');

  /// Base repo lives in data/repo/
  String baseRepoPath() => folderPath('data/repo');

  ///..............service .........///

  /// Concrete remote service — e.g. HomeRemoteService
  String serviceName() => "${toPascalCase(name)}RemoteService";

  String serviceFileName() => '${name}_remote_service.dart';

  /// Abstract base service — e.g. BaseHomeService
  String baseServiceName() => "Base${toPascalCase(name)}Service";

  String baseServiceFileName() => 'base_${name}_service.dart';

  ///..............notifier.........///

  String notifierName() => '${toPascalCase(name)}Notifier';

  String notifierPath(String folder) => folderPath(folder);

  String notifierFileName() => '${name}_notifier.dart';

  ///..............cubit and state.........///
  String cubitName() => '${toPascalCase(name)}Cubit';

  String cubitFileName() => '${name}_cubit.dart';

  String stateFileName() => '${name}_state.dart';

  String stateName() => '${toPascalCase(name)}State';

  String initialStateName() => '${toPascalCase(name)}Loaded';


  ///..............waste_calculator.........///

  final String screenSuffixTxt = "Page";

  String screenName(String secondaryName) => "${toPascalCase(secondaryName)}$screenSuffixTxt";

  String screenFileName(String secondaryName) => '${secondaryName}_screen.dart';

  ///........auto generate data...///
  final String pathRouteSuffix = "Route";
  final String appRouteName = "route";

  String appRoutePath() => "lib/core/app/$appRouteName.dart";

  String routeGenPath() => "lib/core/app/$appRouteName.gr.dart";

  String routeName(String secondaryName) => "${toPascalCase(secondaryName)}$pathRouteSuffix";

  final String singltonPath = "lib/core/constants/app_locator.dart";
  final String typedefPath = "lib/core/constants/app_typedef.dart";
}

class BaseAddRequiredFiles {
  //
  // BaseAddRequiredFiles._();
  makeRequiredFiles(String folder) {
    // Create main folder
    final baseDir = Directory(PathConstants().basePath());
    if (!baseDir.existsSync()) {
      baseDir.createSync(recursive: true);
      print('📁 Created folder: ${baseDir.path}');
    }

    final dir = Directory('${baseDir.path}/$folder');
    print(dir.path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
      print('📂 Created: ${dir.path}');
    }

  }
}
