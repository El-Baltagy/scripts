import '../../create_auto_files/path_constants.dart';
import 'function_script_helpers.dart';

Future<void> addFunctionToService({
  required String featureName,
  required String functionName,
  required String returnType,
  required String paramType,
  required String baseSvcPath,   // abstract base service file
  required String svcPath,       // concrete remote service file
}) async {
  final p = PathConstants();
  final cacheKeyName = '${functionName}KeyCash';

  // ── 1. Inject abstract method signature into BaseHomeService ──────────────
  //
  // The cubit depends on this abstraction — it must declare every callable
  // method so the cubit never touches a concrete type.
  await injectImport(filePath: baseSvcPath, importLine: "import 'package:${p.projectName}/core/constants/app_typedef.dart';");

  await injectIntoClass(
    filePath: baseSvcPath,
    className: p.baseServiceName(),
    displayName: 'base service (abstract)',
    injection: '''
  /// Abstract contract — implemented by [${p.serviceName()}].
  Future<void> ${functionName}Serv(
    RequestCallbackObserver<$returnType, $paramType> requestInfo,
  );''',
    checkDuplicate: 'Future<void> ${functionName}Serv(',
  );

  // ── 2. Inject concrete implementation into HomeRemoteService ──────────────
  //
  // This is where the actual caching + repo call lives.
  // _remoteRepo is typed as BaseHomeRepo (abstraction), not the concrete class.
  await injectImport(filePath: svcPath, importLine: "import 'package:${p.projectName}/core/constants/app_constant.dart';");
  await injectImport(filePath: svcPath, importLine: "import 'package:${p.projectName}/core/constants/app_typedef.dart';");

  await injectIntoClass(
    filePath: svcPath,
    className: p.serviceName(),
    displayName: 'remote service (concrete)',
    injection: '''
  @override
  Future<void> ${functionName}Serv(
    RequestCallbackObserver<$returnType, $paramType> requestInfo,
  ) {
    const cacheKey = AppConstant.$cacheKeyName;
    return requestInfo.handleRequest(
      fetchFromClient: (token) => _remoteRepo.${functionName}Api(
        requestInfo.parameter,
        cancelToken: token,
      ),
      fetchLocal: () async {
        final tuple = await _localRepo.readData(cacheKey);

        if (tuple?.\$1['pr'] == _localRepo.primarySessionId) {
          return $returnType.fromJson(tuple!.\$2);
        }
        return null;
      },
      saveLocal: (old, newData) async {
        if (newData != null) {
          await _localRepo.saveData(cacheKey, savedData: newData.toJson());
        }
      },
      clearLocal: () => _localRepo.clearData(cacheKey),
    );
  }''',
    checkDuplicate: 'Future<void> ${functionName}Serv(',
  );
}
