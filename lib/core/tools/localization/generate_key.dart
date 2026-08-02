import 'dart:convert';
import 'dart:io';

void main(List<String> args) async {
  List<String> inputs = [];

  if (args.isNotEmpty) {
    for (var arg in args) {
      if (arg.contains(',')) {
        inputs.addAll(arg.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty));
      } else {
        final trimmed = arg.trim();
        if (trimmed.isNotEmpty) {
          inputs.add(trimmed);
        }
      }
    }
  } else {
    stdout.write('Enter the English texts or keys to add (comma-separated): ');
    final inputStr = stdin.readLineSync(encoding: utf8) ?? '';
    inputs = inputStr.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  if (inputs.isEmpty) {
    print('❌ Error: You must provide at least 1 key or English text.');
    return;
  }

  final csvPath = 'assets/l10n/translations.csv';
  final file = File(csvPath);

  if (!await file.exists()) {
    print('❌ Error: CSV file not found at $csvPath');
    return;
  }

  // Read the CSV file to determine the number of columns (languages)
  final lines = await file.readAsLines(encoding: utf8);
  if (lines.isEmpty) {
    print('❌ Error: CSV is empty.');
    return;
  }

  final headers = lines.first.split(',');
  final int columnCount = headers.length;

  bool addedAny = false;

  for (final input in inputs) {
    // English value should replace underscores with space
    final englishValue = input.replaceAll('_', ' ').trim();
    if (englishValue.isEmpty) continue;

    // Generate snake_case key
    final key = toSnakeCase(englishValue);

    // Build the new row: [key, englishValue, empty, empty...]
    List<String> newRow = List.filled(columnCount, '');
    newRow[0] = key;
    newRow[1] = _escapeCsv(englishValue);

    final newLine = newRow.join(',');

    // Append to the CSV file
    await file.writeAsString('\n' + newLine, mode: FileMode.append, encoding: utf8);
    
    print('✅ Successfully added "$englishValue" with key "$key" to $csvPath');
    addedAny = true;
  }

  if (addedAny) {
    print('\n🔄 Running auto_translate script...');
    
    final result = await Process.run('dart', ['run', 'lib/core/tools/localization/auto_translate.dart']);
    if (result.exitCode == 0) {
      stdout.write(result.stdout);
    } else {
      print('❌ Failed to run auto_translate:\n${result.stderr}');
    }
  } else {
    print('⚠️ No valid keys were provided.');
  }
}

/// Converts a human-readable string into snake_case.
/// Examples:
/// "Enter your email" -> "enter_your_email"
/// "Login Screen UI" -> "login_screen_ui"
String toSnakeCase(String text) {
  final cleanText = text
      .trim()
      // Replace any non-alphanumeric (except spaces) with space
      .replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), ' ')
      // Collapse multiple spaces into underscore
      .replaceAll(RegExp(r'\s+'), '_')
      .toLowerCase();

  if (cleanText.isEmpty) return 'empty_key';

  // Remove leading digits (keys must start with a letter)
  return cleanText.replaceFirstMapped(RegExp(r'^(\d)'), (m) => '_${m.group(1)}')
                  .replaceAll(RegExp(r'_+$'), '');
}

/// Escapes a CSV value if it contains commas
String _escapeCsv(String value) {
  if (value.contains(',')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}
