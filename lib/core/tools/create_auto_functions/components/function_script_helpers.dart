import 'dart:io';
import '../../create_auto_files/path_constants.dart';

Future<void> injectIntoClass({required String filePath, required String className, required String displayName, required String injection, required String checkDuplicate}) async {
  final file = File(filePath);
  final content = await file.readAsString();
  if (content.contains(checkDuplicate)) {
    print('⚠️  [$displayName] "$checkDuplicate" already exists — skipped.');
    return;
  }
  final lastBrace = content.lastIndexOf('}');
  if (lastBrace == -1) return;
  final updated = content.substring(0, lastBrace) + '\n$injection\n' + content.substring(lastBrace);
  await file.writeAsString(updated);
  print('✅ [$displayName] injected "$checkDuplicate"');
}

// Future<void> appendToEndOfFile({required String filePath, required String displayName, required String injection, required String checkDuplicate}) async {
//   final file = File(filePath);
//   final content = await file.readAsString();
//   if (content.contains(checkDuplicate)) {
//     print('⚠️  [$displayName] "$checkDuplicate" already exists — skipped.');
//     return;
//   }
//   final updated = content.trim() + '\n\n$injection\n';
//   await file.writeAsString(updated);
// }

Future<void> injectImport({required String filePath, required String importLine, bool optional = false}) async {
  final file = File(filePath);
  if (!file.existsSync()) return;
  if (optional) {
    final match = RegExp(r"import 'package:${PathConstants().projectName}/(.*)';").firstMatch(importLine);
    if (match != null) {
      final subPath = match.group(1);
      if (!File('lib/$subPath').existsSync()) return;
    }
  }
  final content = await file.readAsString();
  if (content.contains(importLine)) return;
  final updated = '$importLine\n$content';
  await file.writeAsString(updated);
}

String toSnakeCase(String input) {
  return input.replaceAllMapped(RegExp(r'(?<!^)([A-Z])'), (Match m) => '_${m.group(0)}').toLowerCase();
}


