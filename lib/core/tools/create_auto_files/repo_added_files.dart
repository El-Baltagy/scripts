import 'dart:io';
import '../create_auto_files/path_constants.dart';
import 'path_constants.dart';


class RepoAddRequiredFiles extends BaseAddRequiredFiles {
  RepoAddRequiredFiles();

  @override
  makeRequiredFiles(String folder) async {
    super.makeRequiredFiles(folder);

    final modelDir = Directory('${PathConstants().folderPath(folder)}/model');
    final baseRepoDir = Directory(PathConstants().baseRepoPath());
    final remoteRepoDir = Directory(PathConstants().repoPath());

    /// create model folder
    if (!modelDir.existsSync()) {
      modelDir.createSync(recursive: true);
      print('📁 Created model folder: ${modelDir.path}');
    }

    /// create base repo folder and file (abstract / interface)
    _createBaseRepoDir(baseRepoDir);

    /// create remote repo folder and file (concrete implementation)
    _createRemoteRepoDir(remoteRepoDir);
  }

  void _createBaseRepoDir(Directory dir) {
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
      print('📁 Created base repo folder: ${dir.path}');
    }
    _createBaseRepoClass(dir.path);
  }

  void _createRemoteRepoDir(Directory dir) {
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
      print('📁 Created remote repo folder: ${dir.path}');
    }
    _createRemoteRepoClass(dir.path);
  }
}

// ─── Abstract base repo ────────────────────────────────────────────────────

void _createBaseRepoClass(String basePath) {
  final filePath = '$basePath/${PathConstants().baseRepoFileName()}';
  final file = File(filePath);

  if (!file.existsSync()) {
    final content = '''
import 'package:${PathConstants().projectName}/core/base/base_remote_repo.dart';

/// Abstract contract for the ${PathConstants().name} data layer.
/// High-level modules (services) depend on this, not on concrete implementations.
abstract class ${PathConstants().baseRepoName()} extends BaseRepo {
  // TODO: declare repo method signatures here
}
''';
    file.writeAsStringSync(content);
    print('📄 Created base repo Dart file: $filePath');
  } else {
    print('⚠️ Base repo Dart file already exists: $filePath');
  }
}

// ─── Concrete remote repo ──────────────────────────────────────────────────

void _createRemoteRepoClass(String repoPath) {
  final filePath = '$repoPath/${PathConstants().remoteRepoFileName()}';
  final file = File(filePath);

  if (!file.existsSync()) {
    final content = '''
import 'package:newf/core/shared/methods/print.dart';
import 'package:${PathConstants().projectName}/core/constants/app_api.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:newf/core/api_helper/caller_tag.dart';
import 'package:${PathConstants().projectName}/core/api_helper/dio_error_handler.dart';
import 'package:${PathConstants().projectName}/core/api_helper/dio_helper.dart';
import 'package:${PathConstants().projectName}/core/api_helper/response_handler.dart';
import 'package:${PathConstants().projectName}/features/screens/${PathConstants().name}/data/repo/${PathConstants().baseRepoFileName()}';

/// Concrete remote implementation of [${PathConstants().baseRepoName()}].
class ${PathConstants().repoName()} implements ${PathConstants().baseRepoName()} {
  final DioHelper dio;
  ${PathConstants().repoName()}(this.dio);
}
''';
    file.writeAsStringSync(content);
    print('📄 Created remote repo Dart file: $filePath');
  } else {
    print('⚠️ Remote repo Dart file already exists: $filePath');
  }
}
