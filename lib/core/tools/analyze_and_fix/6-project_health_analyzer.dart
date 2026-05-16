import 'dart:io';

class ProjectHealthAnalyzer {
  final String root;
  ProjectHealthAnalyzer(this.root);

  Future<void> run({required bool autoFix}) async {
    print('\n🔍 Running Project Health Analysis...');

    // 1. Check Circular Imports
    _checkCircularImports();

    // 2. Detect Unused Files & Assets
    final unused = _findUnusedEntities();

    if (unused.dart.isEmpty && unused.assets.isEmpty) {
      print('✅ No unused files or assets found.');
    } else {
      print(
        '⚠️ Found ${unused.dart.length} unused Dart files and ${unused.assets.length} assets.',
      );

      if (autoFix) {
        _performCleanup([...unused.dart, ...unused.assets]);
      } else {
        print('💡 Run with --fix to automatically delete these files.');
        print('--- Unused Dart Files ---');
        unused.dart.forEach((p) => print('  - $p'));
        print('--- Unused Assets ---');
        unused.assets.forEach((p) => print('  - $p'));
      }
    }
  }

  void _checkCircularImports() {
    print('🔄 Checking for circular imports...');
    final dartFiles = Directory('$root/lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();

    final Map<String, List<String>> graph = {};
    for (final file in dartFiles) {
      final content = file.readAsStringSync();
      final imports = RegExp(r"import\s+'([^']+)';")
          .allMatches(content)
          .map((m) => m.group(1)!)
          .where((p) => p.endsWith('.dart'))
          .toList();
      graph[file.path] = imports;
    }

    final visited = <String>{};
    final stack = <String>{};

    void dfs(String node) {
      if (stack.contains(node)) {
        print('❌ Circular import detected: ${node.replaceFirst('$root/', '')}');
        return;
      }
      if (visited.contains(node)) return;

      visited.add(node);
      stack.add(node);

      for (final dep in graph[node] ?? []) {
        final depPath = dartFiles
            .map((f) => f.path)
            .firstWhere((p) => p.endsWith(dep), orElse: () => '');
        if (depPath.isNotEmpty) dfs(depPath);
      }
      stack.remove(node);
    }

    for (final file in dartFiles) {
      dfs(file.path);
    }
  }

  ({List<String> dart, List<String> assets}) _findUnusedEntities() {
    print('🔎 Scanning for unused code and assets...');
    final exclusions = _loadExclusions();
    final packageName = _getPackageName();
    final declaredFonts = _getDeclaredFonts();

    final libFiles = Directory('$root/lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((f) => f.path.endsWith('.dart'))
        .toList();

    final importedFiles = <String>{};
    for (final file in libFiles) {
      final content = file.readAsStringSync();
      final matches = RegExp(
        r"(import|export)\s+'([^']+)'",
      ).allMatches(content);
      for (final m in matches) {
        final uri = m.group(2)!;
        if (uri.startsWith('package:$packageName/')) {
          importedFiles.add('lib/${uri.substring(packageName.length + 9)}');
        } else if (!uri.startsWith('package:') && !uri.startsWith('dart:')) {
          final relPath = _resolveRelative(file.path, uri);
          if (relPath != null) importedFiles.add(relPath);
        }
      }
    }

    final unusedDart = libFiles
        .map((f) => f.path.replaceFirst('$root/', '').replaceAll('\\', '/'))
        .where((path) {
          if (path == 'lib/main.dart' || importedFiles.contains(path))
            return false;
          if (path.endsWith('.g.dart') || path.endsWith('.freezed.dart'))
            return false;
          return !_isExcluded(path, exclusions);
        })
        .toList();

    final assetsDir = Directory('$root/assets');
    final assets = assetsDir.existsSync()
        ? assetsDir.listSync(recursive: true).whereType<File>().toList()
        : <File>[];

    final fullCode = libFiles.map((f) => f.readAsStringSync()).join('\n');
    final unusedAssets = assets
        .map((f) => f.path.replaceFirst('$root/', '').replaceAll('\\', '/'))
        .where((path) {
          if (declaredFonts.contains(path)) return false;
          final name = path.split('/').last;
          return !fullCode.contains(path) &&
              !fullCode.contains(name) &&
              !_isExcluded(path, exclusions);
        })
        .toList();

    return (dart: unusedDart, assets: unusedAssets);
  }

  void _performCleanup(List<String> paths) {
    print('🧹 Cleaning up ${paths.length} unused entities...');
    for (final path in paths) {
      final file = File('$root/$path');
      if (file.existsSync()) {
        file.deleteSync();
        print('  🗑️ Deleted: $path');
      }
    }
    print('✨ Cleanup complete.');
  }

  // Helpers
  String? _resolveRelative(String from, String uri) {
    final parts = from.replaceFirst('$root/', '').split('/')..removeLast();
    for (final segment in uri.split('/')) {
      if (segment == '..') {
        if (parts.isNotEmpty) parts.removeLast();
      } else if (segment != '.')
        parts.add(segment);
    }
    return parts.join('/');
  }

  List<String> _loadExclusions() {
    final f = File('$root/unused_cleaner_config.yaml');
    if (!f.existsSync()) return [];
    return f
        .readAsLinesSync()
        .where((l) => l.startsWith('-'))
        .map((l) => l.replaceFirst('-', '').trim())
        .toList();
  }

  bool _isExcluded(String path, List<String> exclusions) {
    return exclusions.any((e) => path.startsWith(e));
  }

  String _getPackageName() {
    return File('$root/pubspec.yaml')
        .readAsLinesSync()
        .firstWhere((l) => l.startsWith('name:'))
        .split(':')
        .last
        .trim();
  }

  Set<String> _getDeclaredFonts() {
    final content = File('$root/pubspec.yaml').readAsStringSync();
    return RegExp(
      r'asset:\s+([^\s]+)',
    ).allMatches(content).map((m) => m.group(1)!).toSet();
  }
}

Future<void> main(List<String> args) async {
  final autoFix = args.contains('--fix');
  final analyzer = ProjectHealthAnalyzer(Directory.current.path);
  await analyzer.run(autoFix: autoFix);
}
