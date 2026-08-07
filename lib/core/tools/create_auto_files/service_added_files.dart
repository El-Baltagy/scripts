import 'dart:io';
import '../create_auto_files/path_constants.dart';
import 'path_constants.dart';

class ServiceAddRequiredFiles extends BaseAddRequiredFiles {
  ServiceAddRequiredFiles();

  @override
  makeRequiredFiles(String folder) async {
    super.makeRequiredFiles(folder);

    final serviceDir = Directory(PathConstants().folderPath(folder));

    /// create service folder
    if (!serviceDir.existsSync()) {
      serviceDir.createSync(recursive: true);
      print('📁 Created service folder: ${serviceDir.path}');
    }

    /// 1. Abstract base service (the contract cubit depends on)
    _createBaseServiceClass(serviceDir.path);

    /// 2. Concrete remote service (the implementation injected at runtime)
    _createRemoteServiceClass(serviceDir.path);
  }
}

// ─── Abstract base service ─────────────────────────────────────────────────

void _createBaseServiceClass(String servicePath) {
  final filePath = '$servicePath/${PathConstants().baseServiceFileName()}';
  final file = File(filePath);

  if (!file.existsSync()) {
    final content = '''
import 'package:${PathConstants().projectName}/core/base/base_service.dart';

/// Abstract contract for the ${PathConstants().name} service layer.
/// The cubit depends on this, not on a concrete implementation.
abstract class ${PathConstants().baseServiceName()} extends BaseService {
  // TODO: declare service method signatures here
}
''';
    file.writeAsStringSync(content);
    print('📄 Created base service Dart file: $filePath');
  } else {
    print('⚠️ Base service Dart file already exists: $filePath');
  }
}

// ─── Concrete remote service ───────────────────────────────────────────────

void _createRemoteServiceClass(String servicePath) {
  final filePath = '$servicePath/${PathConstants().serviceFileName()}';
  final file = File(filePath);

  if (!file.existsSync()) {
    final content = '''
import 'package:newf/core/shared/methods/print.dart';
import 'package:${PathConstants().projectName}/core/base/base_local_repo.dart';
import 'package:${PathConstants().projectName}/features/screens/${PathConstants().name}/data/repo/${PathConstants().baseRepoFileName()}';
import 'package:${PathConstants().projectName}/features/screens/${PathConstants().name}/service/${PathConstants().baseServiceFileName()}';

/// Concrete implementation of [${PathConstants().baseServiceName()}].
/// Depends on [${PathConstants().baseRepoName()}] (abstraction), not on the remote repo directly.
class ${PathConstants().serviceName()} implements ${PathConstants().baseServiceName()} {
  ${PathConstants().serviceName()}(this._remoteRepo, this._localRepo);

  final ${PathConstants().baseRepoName()} _remoteRepo;
  final BaseLocalRepo _localRepo;
}
''';
    file.writeAsStringSync(content);
    print('📄 Created remote service Dart file: $filePath');
  } else {
    print('⚠️ Remote service Dart file already exists: $filePath');
  }
}
