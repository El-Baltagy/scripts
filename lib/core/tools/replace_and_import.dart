import 'dart:io';

void main( ) {


  final dirPath = "lib/features/screens";
  final findText = "AppColors.contractorDarkText";
  final replaceText = "context.theme.colorScheme.tertiaryFixed";
  final importToAdd = "import 'package:newf/core/extension/context.dart';";

  final directory = Directory(dirPath);
  if (!directory.existsSync()) {
    print('❌ Directory not found: $dirPath');
    exit(1);
  }

  print('📂 Scanning directory: $dirPath');
  print('🔍 Finding: "$findText"');
  print('🔄 Replacing with: "$replaceText"');
  if (importToAdd.isNotEmpty) {
    print('📦 Adding import: "$importToAdd"');
  }
  print('-------------------------------------------');

  int processedCount = 0;
  int updatedCount = 0;

  final files = directory.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    processedCount++;
    var content = file.readAsStringSync();

    if (content.contains(findText)) {
      // 1. Perform replacement
      content = content.replaceAll(findText, replaceText);

      // 2. Add import if specified and not already present
      if (importToAdd.isNotEmpty && !content.contains(importToAdd)) {
        content = _insertImport(content, importToAdd);
      }

      file.writeAsStringSync(content);
      print('✅ Updated: ${file.path}');
      updatedCount++;
    }
  }

  print('-------------------------------------------');
  print('🎉 Done!');
  print('📁 Total files scanned: $processedCount');
  print('📝 Total files updated: $updatedCount');
}

/// Helper method to insert import statements cleanly
String _insertImport(String fileContent, String importStatement) {
  final lines = fileContent.split('\n');
  int lastImportIndex = -1;

  for (int i = 0; i < lines.length; i++) {
    if (lines[i].trim().startsWith('import ')) {
      lastImportIndex = i;
    }
  }

  // Ensure import statement ends with a semicolon
  final formattedImport = importStatement.endsWith(';') ? importStatement : '$importStatement;';

  if (lastImportIndex != -1) {
    // Insert after the last import line
    lines.insert(lastImportIndex + 1, formattedImport);
  } else {
    // No imports found, find first non-comment, non-empty line or insert at top
    int insertIndex = 0;
    for (int i = 0; i < lines.length; i++) {
      final trimmed = lines[i].trim();
      if (trimmed.isEmpty || trimmed.startsWith('//') || trimmed.startsWith('/*')) {
        continue;
      }
      insertIndex = i;
      break;
    }
    lines.insert(insertIndex, '$formattedImport\n');
  }

  return lines.join('\n');
}
