import 'dart:io';
import '../../create_auto_files/path_constants.dart';
import 'function_script_helpers.dart';

Future<void> addFunctionToController({
  required String featureName,
  required String functionName,
  required String returnType,
  required String paramType,
  required String cubitPath,
  required String statePath,
}) async {
  final p = PathConstants();
  final String snakeMethod = toSnakeCase(functionName);
  final keyCodeName = '${functionName}KeyCode';
  final stateVarName = '${functionName}State';

  // 1. Update State File
   await _updateStateClass(statePath, p.initialStateName(), stateVarName);

  // 2. Update Cubit File
  await injectImport(filePath: cubitPath, importLine: "import 'package:${p.projectName}/core/api_helper/cancel/cancel_manager.dart';");

  // Inject KeyCode getter before init()
  await _injectBeforeInit(
    filePath: cubitPath,
    injection: '  int get $keyCodeName => AppConstant.$keyCodeName;',
    checkDuplicate: 'int get $keyCodeName',
  );

  // Inject the Cubit function
  await injectIntoClass(
    filePath: cubitPath,
    className: p.cubitName(),
    displayName: 'cubit',
    injection: '''
  Future<void> ${functionName}Func(BaseRequestBackType baseRequestBackType,{$paramType? parameter}) async {
    await CancelManager.runCancelableFun($keyCodeName, (token) async {
      await _service.${functionName}Serv(
        RequestCallbackObserver<$returnType, $paramType>(
          baseRequestBackType: baseRequestBackType ,
          parameter: parameter,
          cancelToken: token,
          onLoadCallback: () => safeEmit(_current.copyWith($stateVarName: Loading())),
          onRightCallback: (data) => safeEmit(_current.copyWith($stateVarName: Success(data))),
          onLeftCallback: (failure) => safeEmit(_current.copyWith($stateVarName: ErrorState(failure))),
        ),
      );
    });
  }''',
    checkDuplicate: 'Future<void> ${functionName}Func(',
  );

  // Update close() method
  await _updateCloseMethod(
    filePath: cubitPath,
    keyCodeName: keyCodeName,
  );
}

Future<void> _updateStateClass(String filePath, String className, String stateVarName) async {
  final file = File(filePath);
  if (!file.existsSync()) return;
  String content = await file.readAsString();

  if (content.contains('this.$stateVarName')) {
    print('⚠️  [state] "$stateVarName" already exists in state class — skipped.');
    return;
  }

  // 1. Add to constructor
  final constructorMatch = RegExp('class $className.*?{.*?$className\\(\\{', dotAll: true).firstMatch(content);
  if (constructorMatch != null) {
    final insertPos = constructorMatch.end;
    content = content.substring(0, insertPos) + '\n    this.$stateVarName,' + content.substring(insertPos);
  }

  // 2. Add to fields
  final fieldsMatch = RegExp('final\\s+BaseEmit\\??\\s+([a-zA-Z0-9_,\\s]*);').firstMatch(content);
  if (fieldsMatch != null) {
    final insertPos = fieldsMatch.end - 1; // Before the semicolon
    content = content.substring(0, insertPos) + ', $stateVarName' + content.substring(insertPos);
  } else {
    // If no BaseEmit fields exist, add it before copyWith
    final copyWithMatch = RegExp('$className\\s+copyWith\\(\\{').firstMatch(content);
    if (copyWithMatch != null) {
      final insertPos = copyWithMatch.start;
      content = content.substring(0, insertPos) + '  final BaseEmit? $stateVarName;\n\n  ' + content.substring(insertPos);
    }
  }

  // 3. Add to copyWith arguments
  final copyWithArgsMatch = RegExp('$className\\s+copyWith\\(\\{').firstMatch(content);
  if (copyWithArgsMatch != null) {
    final insertPos = copyWithArgsMatch.end;
    content = content.substring(0, insertPos) + '\n    BaseEmit? $stateVarName,' + content.substring(insertPos);
  }

  // 4. Add to copyWith return
  final returnMatch = RegExp('return\\s+$className\\(').firstMatch(content);
  if (returnMatch != null) {
    final insertPos = returnMatch.end;
    content = content.substring(0, insertPos) + '\n      $stateVarName: $stateVarName ?? this.$stateVarName,' + content.substring(insertPos);
  }

  await file.writeAsString(content);
  print('✅ [state] updated $className with $stateVarName');
}

Future<void> _injectBeforeInit({required String filePath, required String injection, required String checkDuplicate}) async {
  final file = File(filePath);
  String content = await file.readAsString();
  if (content.contains(checkDuplicate)) return;
  
  // Find the start of the init() declaration, including optional annotations and return types
  final initMatch = RegExp(r'(?:@override\s+)?(?:Future<void>\s+)?init\(\)').firstMatch(content);
  if (initMatch == null) return;
  
  final targetIndex = initMatch.start;
  final updated = content.substring(0, targetIndex) + '$injection\n\n  ' + content.substring(targetIndex);
  await file.writeAsString(updated);
}

Future<void> _updateCloseMethod({required String filePath, required String keyCodeName}) async {
  final file = File(filePath);
  String content = await file.readAsString();
  final String cancelLine = '    CancelManager.cancel($keyCodeName);';
  
  if (content.contains(cancelLine)) return;

  if (content.contains('Future<void> close()')) {
    // Append to existing close()
    final closeMatch = RegExp(r'Future<void> close\(\)\s*\{').firstMatch(content);
    if (closeMatch != null) {
      final insertPos = content.indexOf('{', closeMatch.start) + 1;
      final updated = content.substring(0, insertPos) + '\n    // add every key in file\n$cancelLine\n' + content.substring(insertPos);
      await file.writeAsString(updated);
    }
  } else {
    // Add new close() before the last brace
    final lastBrace = content.lastIndexOf('}');
    final String closeMethod = '''
  @override
  Future<void> close() {
    // add every key in file
$cancelLine
    return super.close();
  }
''';
    final updated = content.substring(0, lastBrace) + closeMethod + content.substring(lastBrace);
    await file.writeAsString(updated);
  }
}
