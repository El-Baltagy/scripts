// ignore_for_file: avoid_print
import 'dart:io';

/// Bulk Feature Documentation Generator
///
/// Scans the `lib/features/screens` directory and automatically runs
/// `feature_doc_generator.dart` for every feature folder it finds.
///
/// Usage:
///   dart run lib/core/tools/mcp/generate_all_features_docs.dart

Future<void> main() async {
  final screensDir = Directory('lib/features/screens');
  if (!screensDir.existsSync()) {
    print('❌ Directory not found: lib/features/screens');
    exit(1);
  }

  print('🚀 Starting bulk generation for all features...\n');

  // Find all feature folders inside lib/features/screens
  final features = screensDir
      .listSync()
      .whereType<Directory>()
      .map((d) => d.uri.pathSegments[d.uri.pathSegments.length - 2])
      .toList();

  if (features.isEmpty) {
    print('⚠️ No feature folders found in lib/features/screens');
    return;
  }

  int successCount = 0;
  int errorCount = 0;

  for (final feature in features) {
    print('⏳ Generating docs for: $feature ...');

    // Run the individual feature documentation generator script
    final result = await Process.run('dart', [
      'run',
      'lib/core/tools/mcp/feature_doc_generator.dart',
      feature,
    ]);

    if (result.exitCode == 0) {
      print('✅ $feature generated successfully.');
      successCount++;
    } else {
      print('❌ Failed to generate docs for $feature.');
      print('   Error: ${result.stderr.toString().trim()}');
      print('   Output: ${result.stdout.toString().trim()}');
      errorCount++;
    }
  }

  print('\n🎉 Bulk generation complete!');
  print('📊 Summary: $successCount succeeded, $errorCount failed.');
  print('📂 All generated/updated files are located in `lib/core/ai_guide/`');
}
