/// Captures the calling file and method at the point this function is called.
///
/// IMPORTANT: always call this SYNCHRONOUSLY at the top of your method,
/// before any `await`. Dart's async machinery adds extra stack frames after
/// the first suspension point, which would make [_getCallerFunction] see
/// the wrong frame.
///
/// Usage in a repo method:
/// ```dart
/// Future<Either<Failure, T>> myApiMethod() async {
///   final tag = callerTag(); // ← must be first line
///   return handleResponse(caller: tag, ...);
/// }
/// ```
String callerTag([int skip = 1]) => _resolveFrame(StackTrace.current, skip);

String _resolveFrame(StackTrace stack, int skip) {
  try {
    final lines = stack.toString().split('\n');
    // skip=1 → skip callerTag() itself, land on the actual caller
    for (int i = skip; i < lines.length; i++) {
      final line = lines[i];
      if (line.contains('.dart')) {
        // Dart stack trace lines usually look like:
        // #1      ClassName.methodName (package:app/path/file.dart:10:5)
        // This regex extracts "package:app/path/file.dart:10:5"
        final pathMatch =
            RegExp(r'\((package:[^)]+|\w+://[^)]+|/[^)]+\.dart[^)]*)\)').firstMatch(line) ??
            RegExp(r'(package:[^\s]+|\w+://[^\s]+|/[^\s]+\.dart[^\s]*)').firstMatch(line);

        final methodMatch =
            RegExp(r'#\d+\s+([^\s]+)\s+').firstMatch(line);

        final filePath = pathMatch != null
            ? pathMatch
                .group(1)!
                .replaceAll('package:', '')
                .replaceAll(RegExp(r'^[^/]+/'), 'lib/')
            : 'unknown_file.dart';

        final method = methodMatch?.group(1) ?? 'unknown_method';
        
        // Outputting exactly this format makes it clickable in VS Code/Android Studio
        return '$filePath → $method';
      }
    }
    return 'unknown caller';
  } catch (_) {
    return 'unknown caller';
  }
}
