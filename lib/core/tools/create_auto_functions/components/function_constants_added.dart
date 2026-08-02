import 'function_script_helpers.dart';

Future<void> registerConstant(String keyName, String keyValue) async {
  final path = 'lib/core/constants/app_constant.dart';
  final injection = "  static const String $keyName = '$keyValue';";
  await injectIntoClass(
    filePath: path,
    className: 'AppConstant',
    displayName: 'AppConstant',
    injection: injection,
    checkDuplicate: "static const String $keyName",
  );
}

Future<void> registerIntConstant(String keyName, int keyValue) async {
  final path = 'lib/core/constants/app_constant.dart';
  final injection = "  static const int $keyName = $keyValue;";
  await injectIntoClass(
    filePath: path,
    className: 'AppConstant',
    displayName: 'AppConstant',
    injection: injection,
    checkDuplicate: "static const int $keyName",
  );
}

Future<void> registerApiEndpoint(String functionName) async {
  final path = 'lib/core/constants/app_api.dart';
  final injection = "  static const String $functionName = '/api/\$functionName';";
  await injectIntoClass(
    filePath: path,
    className: 'EndPoints',
    displayName: 'EndPoints',
    injection: injection,
    checkDuplicate: "static const String $functionName",
  );
}
