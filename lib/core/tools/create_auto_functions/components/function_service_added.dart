import '../../create_auto_files/path_constants.dart';
import 'function_script_helpers.dart';

Future<void> addFunctionToService({
  required String featureName,
  required String functionName,
  required String returnType,
  required String paramType,
  required String svcPath,
}) async {
  final p = PathConstants();
  final String snakeMethod = toSnakeCase(functionName);
  final cacheKeyName = '${functionName}KeyCash';

  await injectImport(filePath: svcPath, importLine: "import 'package:${p.projectName}/core/constants/app_constant.dart';");
  await injectImport(filePath: svcPath, importLine: "import 'package:${p.projectName}/core/constants/app_typedef.dart';");
  // await injectImport(filePath: svcPath, importLine: "import 'package:${p.projectName}/features/screens/$featureName/data/model/$snakeMethod/$snakeMethod.dart';");
  // await injectImport(filePath: svcPath, importLine: "import 'package:${p.projectName}/features/screens/$featureName/data/model/$snakeMethod/${snakeMethod}_req_param.dart';");

  await injectIntoClass(
    filePath: svcPath,
    className: p.serviceName(),
    displayName: 'service',
    injection: '''
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
          return StatisticsRes.fromJson(tuple!.\$2);
        }
        return null; 
      },
      saveLocal: (old, newData) async {
        if (newData != null) {
          await _localRepo.saveData(cacheKey,savedData: newData.toJson());
        }
      },
      clearLocal: () => _localRepo.clearData(cacheKey),
    );
  }''',
    checkDuplicate: 'Future<void> ${functionName}Serv(',
  );
}
