// ─────────────────────────────────────────────────────────────────────────────
// 1-setup_l10n.dart
// One-shot script that fully wires flutter gen-l10n into your project:
//
//  ✅  Adds flutter_localizations + intl to pubspec.yaml
//  ✅  Adds `generate: true` under the flutter: section
//  ✅  Creates l10n.yaml in the project root
//  ✅  Creates assets folder with starter CSV & json files
//  ✅  Runs `flutter pub get` & `flutter gen-l10n`
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'dart:io';
import '../create_auto_files/path_constants.dart';

// ── Configuration ─────────────────────────────────────────────────────────────
const String ASSETS_L10N_PATH = 'assets/l10n';
const String CSV_FILE_NAME = 'translations.csv';
const String OUTPUT_FILE = 'app_localizations.dart';

// ─── ANSI colours ────────────────────────────────────────────────────────────
const _g = '\x1B[32m'; // green
const _y = '\x1B[33m'; // yellow
const _r = '\x1B[31m'; // red
const _c = '\x1B[36m'; // cyan
const _b = '\x1B[1m'; // bold
const _x = '\x1B[0m'; // reset

void main(List<String> args) async {
  _banner();

  final root = Directory.current.path;

  // Guard: must be run from project root
  if (!File('$root/pubspec.yaml').existsSync()) {
    _err('Run this from the Flutter project root (where pubspec.yaml is).');
    exit(1);
  }

  // ── Default Locales ─────────────────────────────────────────────────────────
  // Generate just 'en' initially. Other languages can be added later via the CSV.
  final List<String> locales = ['en'];
  final templateArb = 'app_en.json';

  // ── Steps ───────────────────────────────────────────────────────────────────
  bool pubspecChanged = await _step1_pubspec(root);
  await _step2_assetsFolder(root, locales);
  // await _step3_l10nYaml(root, templateArb); // Removed per user request

  if (pubspecChanged) {
    await _step4_pubGet(root);
  } else {
    _skip('Skipping flutter pub get (No dependencies added)');
  }
  // await _step5_genL10n(root); // Removed per user request

  await _step7_createLocalizationFile(root);
  await _step8_patchMain(root);

  _step6_usage();
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 1 — patch pubspec.yaml
// ─────────────────────────────────────────────────────────────────────────────
Future<bool> _step1_pubspec(String root) async {
  _header('1/5  Patching pubspec.yaml');

  final file = File('$root/pubspec.yaml');
  var content = file.readAsStringSync();
  bool changed = false;
  // easy_localization: ^3.0.5
  // 1a. Add flutter_localizations under dependencies:
  if (!content.contains('easy_localization')) {
    content = content.replaceFirstMapped(
      RegExp(r'(dependencies:\s*\n\s*flutter:\s*\n\s*sdk:\s*flutter)'),
          (match) =>
      '${match.group(1)}\n\n  easy_localization: ^3.0.5\n',
    );
    _ok('Added easy_localization dependency');
    changed = true;
  } else {
    _skip('easy_localization already present');
  }

  // 1b. Add intl
  if (!content.contains(RegExp(r'^\s*intl:', multiLine: true))) {
    content = content.replaceFirst(
      'easy_localization: ^3.0.5',
      'easy_localization: ^3.0.5  \n  intl: ^0.20.0',
    );
    _ok('Added intl dependency');
    changed = true;
  } else {
    _skip('intl already present');
  }

  // 1c. Add generate: true under flutter: section
  if (!content.contains('generate: true')) {
    content = content.replaceFirstMapped(
      RegExp(r'(^flutter:\s*\n)', multiLine: true),
          (m) => '${m.group(1)}  generate: true\n',
    );
    _ok('Added `generate: true` to flutter: section');
    changed = true;
  } else {
    _skip('generate: true already set');
  }


  if (changed) {
    file.writeAsStringSync(content);
    _ok('pubspec.yaml saved ✓');
  }

  return changed;
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 2 — create assets folder, CSV, and json files
// ─────────────────────────────────────────────────────────────────────────────
Future<void> _step2_assetsFolder(String root, List<String> locales) async {
  _header('2/5  Scaffolding $ASSETS_L10N_PATH/ folder');

  final dir = Directory('$root/$ASSETS_L10N_PATH');
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
    _ok('Created directory: $ASSETS_L10N_PATH/');
  }

  // 1. Create CSV file
  final csvFile = File('$root/$ASSETS_L10N_PATH/$CSV_FILE_NAME');
  if (!csvFile.existsSync()) {
    final header = 'key,${locales.join(',')}';
    // Sample rows
    final row1 = 'app_name,' + locales.map((l) => 'My App').join(',');

    csvFile.writeAsStringSync('$header\n$row1\n', encoding: utf8);
    _ok('Created starter CSV file: $CSV_FILE_NAME');
  } else {
    _skip('CSV file already exists');
  }

  // 2. Create ARB files based on locales
  for (final locale in locales) {
    final fileName = 'app_$locale.json';
    final file = File('$root/$ASSETS_L10N_PATH/$fileName');

    if (!file.existsSync()) {
      final json = <String, dynamic>{'@@locale': locale, 'appName': 'My App'};

      const encoder = JsonEncoder.withIndent('  ');
      file.writeAsStringSync(encoder.convert(json), encoding: utf8);
      _ok('Created json file: $fileName');
    } else {
      _skip('json file $fileName already exists');
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 3 — create l10n.yaml (REMOVED per user request)
// ─────────────────────────────────────────────────────────────────────────────

// ─────────────────────────────────────────────────────────────────────────────
// Step 4 — flutter pub get
// ─────────────────────────────────────────────────────────────────────────────
Future<void> _step4_pubGet(String root) async {
  _header('4/5  Running flutter pub get');

  final result = await Process.run(
    'flutter',
    ['pub', 'get'],
    workingDirectory: root,
    runInShell: true,
  );

  if (result.exitCode == 0) {
    _ok('flutter pub get succeeded');
  } else {
    _err('flutter pub get failed:\n${result.stderr}');
    exit(1);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 5 — flutter gen-l10n (REMOVED per user request)
// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// Step 6 — print usage guide
// ─────────────────────────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────────────────
// Step 7 — create lib/localization.dart
// ─────────────────────────────────────────────────────────────────────────────
Future<void> _step7_createLocalizationFile(String root) async {
  _header('6/5  Checking lib/localization.dart');
  final file = File('$root/lib/localization.dart');
  if (!file.existsSync()) {
    const code = '''import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CodegenLoader extends RootBundleAssetLoader {
  CodegenLoader._internal();

  static final CodegenLoader _instance = CodegenLoader._internal();

  factory CodegenLoader() => _instance;

  final Map<String, Map<String, dynamic>> _cache = {};

  static const String assetTranslationsPath = 'assets/l10n';
  static Locale get fallBackLocale => const Locale('en');
  static List<Locale> supportedLocales = [];

  Locale _currentLocale = const Locale('en');
  Locale get currentLocale => _currentLocale;

  void setLocale(Locale locale) {
    _currentLocale = locale;
  }

  static Future<void> init() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final localeFiles = manifestMap.keys
        .where(
          (path) =>
              path.startsWith('\$assetTranslationsPath/') &&
              path.endsWith('.json'),
        )
        .toList();

    supportedLocales = localeFiles.map((filePath) {
      final fileName = filePath.split('/').last;
      final localeCode = fileName.split('_').last.replaceAll('.json', '');
      return Locale(localeCode);
    }).toList();
    
    // Set default locale via singleton instance
    _instance.setLocale(const Locale('en'));
  }

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    final localeKey = locale.languageCode;

    if (_cache.containsKey(localeKey)) {
      return _cache[localeKey]!;
    }

    final jsonString = await rootBundle.loadString(
      '\$assetTranslationsPath/app_\$localeKey.json',
    );

    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _cache[localeKey] = jsonMap;
    return jsonMap;
  }
}
''';
    file.writeAsStringSync(code);
    _ok('Created lib/localization.dart with CodegenLoader');
  } else {
    _skip('lib/localization.dart already exists');
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 8 — patch lib/main.dart
// ─────────────────────────────────────────────────────────────────────────────
Future<void> _step8_patchMain(String root) async {
  _header('7/5  Patching lib/main.dart');
  final file = File('$root/lib/main.dart');
  if (!file.existsSync()) {
    _warn('lib/main.dart not found, skipping auto-wire.');
    return;
  }

  var content = file.readAsStringSync();
  bool changed = false;

  // 1. Add imports
  final List<String> neededImports = [
    "import 'package:easy_localization/easy_localization.dart';",
    "import 'package:${PathConstants().projectName}/localization.dart';",
    "// import 'generated/codegen_loader.g.dart'; // Ensure this exists after generation",
  ];

  for (final imp in neededImports) {
    if (!content.contains(imp.split('//').first.trim())) {
      content = '$imp\n$content';
      changed = true;
    }
  }

  // 2. Patch main() and runApp
  if (content.contains('void main()')) {
    content = content.replaceFirst('void main()', 'Future<void> main() async');
    changed = true;
  }

  if (!content.contains('WidgetsFlutterBinding.ensureInitialized()')) {
    content = content.replaceFirst(
      'Future<void> main() async {',
      'Future<void> main() async {\n  WidgetsFlutterBinding.ensureInitialized();',
    );
    changed = true;
  }

  if (!content.contains('CodegenLoader.init()')) {
    content = content.replaceFirst(
      'WidgetsFlutterBinding.ensureInitialized();',
      'WidgetsFlutterBinding.ensureInitialized();\n  await CodegenLoader.init();',
    );
    changed = true;
  }

  if (content.contains('runApp(const MyApp());') || content.contains('runApp(MyApp());')) {
    final oldRunApp = content.contains('runApp(const MyApp());')
        ? 'runApp(const MyApp());'
        : 'runApp(MyApp());';

    final newRunApp = '''  runApp(
    EasyLocalization(
      supportedLocales: CodegenLoader.supportedLocales,
      fallbackLocale: CodegenLoader.fallBackLocale,
      path: CodegenLoader.assetTranslationsPath,
      assetLoader: CodegenLoader(),
      child: const MyApp(),
    ),
  );''';

    if (!content.contains('EasyLocalization(')) {
      content = content.replaceFirst(oldRunApp, newRunApp);
      _ok('Wrapped runApp with EasyLocalization');
      changed = true;
    }
  }

  // 3. Patch MaterialApp
  if (content.contains('MaterialApp(') && !content.contains('localizationDelegates:')) {
    const l10nProps = '''      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,''';

    content = content.replaceFirst(
      'MaterialApp(',
      'MaterialApp(\n$l10nProps',
    );
    _ok('Added localization delegates to MaterialApp');
    changed = true;
  }

  if (changed) {
    file.writeAsStringSync(content);
    _ok('lib/main.dart updated ✓');
  } else {
    _skip('lib/main.dart already has localization wiring');
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 6 — print usage guide
// ─────────────────────────────────────────────────────────────────────────────
void _step6_usage() {
  print(
    '\n$_b$_c━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$_x',
  );
  print('$_b🎉 Localization setup complete!$_x\n');

  print('${_b}Next Steps:$_x');
  print('1. Ensure you have translation files in assets/l10n/');
  print('2. Run your localization generation tool (e.g., easy_localization:generate)');
  print('3. Review lib/main.dart for any import errors (CodegenLoader, etc.)');
  print('4. Happy coding!');

  print('$_c━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$_x\n');
}

void _banner() {
  print('''
$_b$_c
╔══════════════════════════════════════════════════════╗
║      ⚙️   Flutter gen-l10n Setup Script   ⚙️         ║
║          Automatic localization wiring               ║
╚══════════════════════════════════════════════════════╝
$_x''');
}

void _header(String msg) => print('\n$_b$_y▶ $msg$_x');
void _ok(String msg) => print('  $_g✅ $msg$_x');
void _skip(String msg) => print('  $_c⏭  $msg$_x');
void _warn(String msg) => print('  $_y⚠️  $msg$_x');
void _err(String msg) => print('  $_r❌ $msg$_x');
void _detail(String msg) => print('$_c$msg$_x');
