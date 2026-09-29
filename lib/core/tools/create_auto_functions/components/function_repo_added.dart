import '../../create_auto_files/path_constants.dart';
import 'function_script_helpers.dart';

Future<void> addFunctionToRepo({
  required String featureName,
  required String functionName,
  required String returnType,
  required String paramType,
  required String baseRepoPath,   // abstract base repo file
  required String repoPath,       // concrete remote repo file
}) async {
  final p = PathConstants();

  // ── 1. Inject abstract method signature into BaseHomeRepo ─────────────────
  //
  // High-level modules (services) depend on this abstraction, so the contract
  // must be declared here.  No implementation goes in the base class.
  await injectImport(filePath: baseRepoPath, importLine: "import 'package:dartz/dartz.dart';");
  await injectImport(filePath: baseRepoPath, importLine: "import 'package:dio/dio.dart';");
  await injectImport(filePath: baseRepoPath, importLine: "import 'package:${p.projectName}/core/api_helper/dio_error_handler.dart';");

  await injectIntoClass(
    filePath: baseRepoPath,
    className: p.baseRepoName(),
    displayName: 'base repo (abstract)',
    injection: '''
  /// Abstract contract — implemented by [${p.repoName()}].
  Future<Either<Failure, $returnType>> ${functionName}Api(
    $paramType? parameter, {
    CancelToken? cancelToken,
  });''',
    checkDuplicate: 'Future<Either<Failure, $returnType>> ${functionName}Api(',
  );

  // ── 2. Inject concrete implementation into HomeRemoteRepo ─────────────────
  //
  // This is the only place that knows about DioHelper and actual HTTP calls.
  await injectImport(filePath: repoPath, importLine: "import 'package:${p.projectName}/core/constants/app_constant.dart';");
  await injectImport(filePath: repoPath, importLine: "import 'package:dartz/dartz.dart';");
  await injectImport(filePath: repoPath, importLine: "import 'package:dio/dio.dart';");
  await injectImport(filePath: repoPath, importLine: "import 'package:${p.projectName}/core/api_helper/dio_error_handler.dart';");

  await injectIntoClass(
    filePath: repoPath,
    className: p.repoName(),
    displayName: 'remote repo (concrete)',
    injection: '''
  @override
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
