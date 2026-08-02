import '../../create_auto_files/path_constants.dart';
import 'function_script_helpers.dart';

Future<void> addFunctionToRepo({
  required String featureName,
  required String functionName,
  required String returnType,
  required String paramType,
  required String repoPath,
}) async {
  final p = PathConstants();
  final String snakeMethod = toSnakeCase(functionName);
   await injectImport(filePath: repoPath, importLine: "import 'package:${p.projectName}/core/constants/app_constant.dart';");
  await injectImport(filePath: repoPath, importLine: "import 'package:dartz/dartz.dart';");
  await injectImport(filePath: repoPath, importLine: "import 'package:${p.projectName}/core/api_helper/dio_error_handler.dart';");
  // await injectImport(filePath: repoPath, importLine: "import 'package:${p.projectName}/features/screens/$featureName/data/model/$snakeMethod/$snakeMethod.dart';");
  // await injectImport(filePath: repoPath, importLine: "import 'package:${p.projectName}/features/screens/$featureName/data/model/$snakeMethod/${snakeMethod}_req_param.dart';");

  await injectIntoClass(
    filePath: repoPath,
    className: p.repoName(),
    displayName: 'remote repo',
    injection: '''
  Future<Either<Failure, $returnType>> ${functionName}Api(
    $paramType? parameter, {
    CancelToken? cancelToken,
  }) async {
    return handleResponse(
      onCallData: dio.getData(
        uri: EndPoints.$functionName,
        cancelToken: cancelToken,
        caller: callerTag(),
      ),
      asObject: $returnType.fromJson,
    );
  }''',
    checkDuplicate: 'Future<Either<Failure, $returnType>> ${functionName}Api(',
  );
}
