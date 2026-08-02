import 'package:dio/dio.dart';

extension FormDataExtension on FormData {
  String toDebugString() {
    final buffer = StringBuffer();

    buffer.writeln('========== FormData ==========');

    if (fields.isNotEmpty) {
      buffer.writeln('Fields:');
      for (final field in fields) {
        buffer.writeln('  ${field.key}: ${field.value}');
      }
    }

    if (files.isNotEmpty) {
      buffer.writeln('Files:');
      for (final file in files) {
        buffer.writeln(
          '  ${file.key}: ${file.value.filename}'
              ' (${file.value.contentType ?? 'unknown'})',
        );
      }
    }

    buffer.write('==============================');

    return buffer.toString();
  }
}