// ignore_for_file: avoid_print
import 'dart:io';

/// Feature Documentation Generator
///
/// Scans a feature folder inside `lib/features/screens/<featureName>` and
/// generates a comprehensive Markdown guide at
/// `lib/core/ai_guide/<featureName>.md`.
///
/// Usage:
///   dart run lib/core/tools/mcp/feature_doc_generator.dart <feature_name>
///
/// Example:
///   dart run lib/core/tools/mcp/feature_doc_generator.dart main_screen

// ─── helpers ────────────────────────────────────────────────────────────────

/// Converts `snake_case` to `TitleCase`
String toTitle(String s) =>
    s.split('_').map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

/// Converts `snake_case` to `PascalCase`
String toPascal(String s) =>
    s.split('_').map((w) => w.isEmpty ? '' : '${w[0].toUpperCase()}${w.substring(1)}').join('');

/// Read a file safely; returns empty string if it doesn't exist.
String _read(String path) {
  final f = File(path);
  return f.existsSync() ? f.readAsStringSync() : '';
}

/// List dart files inside a directory (non-recursive).
List<File> _dartFiles(String dir) {
  final d = Directory(dir);
  if (!d.existsSync()) return [];
  return d
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();
}

/// List dart files recursively inside a directory.
List<File> _dartFilesRecursive(String dir) {
  final d = Directory(dir);
  if (!d.existsSync()) return [];
  return d
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();
}

// ─── section builders ────────────────────────────────────────────────────────

String _buildHeader(String featureName) {
  final title = toTitle(featureName);
  final now = DateTime.now();
  final featureRelativePath = '../../features/screens/$featureName';

  return '''
# 📋 Feature Guide: $title

## 🔗 [📁 Open Feature Folder (`lib/features/screens/$featureName`)]($featureRelativePath)

> **Auto-generated** on ${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}  
> Source: `lib/features/screens/$featureName/`  
> Design rules: `lib/core/ai_guide/AI_GENERAL_PROMPT_FOR_DESIGN_GUIDE.md`

---

## 📌 Design Rules Quick-Reference
| Rule | Detail |
|------|--------|
| Routing | `@RoutePage()` + `AutoRouteWrapper` |
| State | BLoC / Cubit (`BlocBuilder` + `BlocListener`) |
| Lifecycle | Abstract `BaseState` via mixin file |
| Widget extraction | Every component → separate file in `widgets/` |
| Spacing | `n.verticalSpace` / `n.horizontalSpace` (no raw `SizedBox`) |
| Colors | `AppColors` only – no hardcoded hex |
| Typography | `AppTextStyles` + `.copyWith()` – no inline `TextStyle` |
| Padding/Sizes | `AppPadding.pN` / `AppSizes.sN` constants |
| Semantics | Outermost wrapper on every root widget |
| Imports | Package imports only (`package:…`) |
| Strings | Via `generate_key.dart` → `'key'.tr()` |
| Const | Use `const` constructors everywhere possible |
| Build limit | Single `build()` method ≤ 100 lines |

---
''';
}

// ── Controller ───────────────────────────────────────────────────────────────

String _buildControllerSection(String base, String featureName) {
  final pascal = toPascal(featureName);
  final cubitPath = '$base/controller/${featureName}_cubit.dart';
  final statePath = '$base/controller/${featureName}_state.dart';

  final cubitSrc = _read(cubitPath);
  final stateSrc = _read(statePath);

  // Extract method signatures from the cubit
  final methodRx = RegExp(r'Future<\w+>\s+(\w+)\(([^)]*)\)', multiLine: true);
  final methods = methodRx.allMatches(cubitSrc).map((m) {
    final name = m.group(1)!;
    final params = m.group(2)?.trim() ?? '';
    return '- `$name($params)`';
  }).join('\n');

  // Extract state fields from the state file
  final fieldRx = RegExp(r'final\s+\S+\?\s+(\w+);', multiLine: true);
  final stateFields = fieldRx.allMatches(stateSrc).map((m) => '- `${m.group(1)}`').join('\n');

  return '''
## 🎛️ Controller

### Files
| File | Description |
|------|-------------|
| `controller/${featureName}_cubit.dart` | Business logic, emits states |
| `controller/${featureName}_state.dart` | State model (`${pascal}Loaded`, …) |

### Cubit: `${pascal}Cubit`
- Extends **`BaseCubit<${pascal}State>`**
- Uses `CancelManager` for cancellable network requests
- Static accessor: `${pascal}Cubit.get(context: context)`
- Holds an instance of `Base${pascal}Service` (injected via DI)

${methods.isNotEmpty ? '### Methods\n$methods' : '### Methods\n_No public async methods found yet (TODO stubs)._'}

### State: `${pascal}Loaded`
${stateFields.isNotEmpty ? '**State fields (nullable `BaseEmit`):**\n$stateFields' : '_No state fields declared yet._'}

- Uses `copyWith()` pattern so only the relevant slice of state changes per action
- `allWorkersEmit` → broadcast channel for global listeners

---
''';
}

// ── Data / Repo ───────────────────────────────────────────────────────────────

String _buildDataSection(String base, String featureName) {
  final pascal = toPascal(featureName);

  final baseRepoPath = '$base/data/repo/base_${featureName}_repo.dart';
  final remoteRepoPath = '$base/data/repo/${featureName}_remote_repo.dart';
  final baseRepoSrc = _read(baseRepoPath);
  final remoteRepoSrc = _read(remoteRepoPath);

  // Gather model files
  final modelFiles = _dartFilesRecursive('$base/data/model')
      .map((f) => '- `data/model/${f.uri.pathSegments.last}`')
      .join('\n');

  // Extract abstract repo method signatures
  final methodRx = RegExp(r'Future<[^>]+>\s+(\w+)\(([^)]*)\)', multiLine: true);
  final baseRepoMethods = methodRx.allMatches(baseRepoSrc).map((m) {
    return '- `${m.group(1)}(${m.group(2)?.trim()})`';
  }).join('\n');

  // Extract endpoint usages from remote repo
  final endpointRx = RegExp(r'EndPoints\.(\w+)', multiLine: true);
  final endpoints = endpointRx
      .allMatches(remoteRepoSrc)
      .map((m) => '`EndPoints.${m.group(1)}`')
      .toSet()
      .join(', ');

  return '''
## 🗄️ Data Layer

### Files
| File | Description |
|------|-------------|
| `data/repo/base_${featureName}_repo.dart` | Abstract contract for repo |
| `data/repo/${featureName}_remote_repo.dart` | Concrete Dio implementation |
| `data/model/` | Response / entity models |

### `Base${pascal}Repo` (abstract)
Declares method contracts — services depend on this abstraction, never on the concrete class.

${baseRepoMethods.isNotEmpty ? '**Declared methods:**\n$baseRepoMethods' : '_No methods declared yet._'}

### `${pascal}RemoteRepo`
- Implements `Base${pascal}Repo`
- Uses **`DioHelper`** for HTTP calls
- Wraps responses via `handleResponse(asObject: Model.fromJson)`
${endpoints.isNotEmpty ? '- Endpoints used: $endpoints' : ''}

### Models
${modelFiles.isNotEmpty ? modelFiles : '_No model files found yet._'}

---
''';
}

// ── Service ───────────────────────────────────────────────────────────────────

String _buildServiceSection(String base, String featureName) {
  final pascal = toPascal(featureName);

  final baseServPath = '$base/service/base_${featureName}_service.dart';
  final remoteServPath = '$base/service/${featureName}_remote_service.dart';
  final baseServSrc = _read(baseServPath);

  final methodRx = RegExp(r'Future<\w+>\s+(\w+)\(([^)]*)\)', multiLine: true);
  final serviceMethods = methodRx.allMatches(baseServSrc).map((m) {
    return '- `${m.group(1)}(${m.group(2)?.trim()})`';
  }).join('\n');

  // Check if local caching is used
  final remoteSrc = _read(remoteServPath);
  final hasCache = remoteSrc.contains('_localRepo') || remoteSrc.contains('cacheKey');
  final hasSave = remoteSrc.contains('saveLocal');

  return '''
## 🔧 Service Layer

### Files
| File | Description |
|------|-------------|
| `service/base_${featureName}_service.dart` | Abstract service contract |
| `service/${featureName}_remote_service.dart` | Orchestrates repo + caching |

### `Base${pascal}Service` (abstract)
Bridge between Cubit and Repo — the Cubit only sees this interface.

${serviceMethods.isNotEmpty ? '**Service methods:**\n$serviceMethods' : '_No methods declared yet._'}

### `${pascal}RemoteService`
- Depends on `Base${pascal}Repo` and `BaseLocalRepo`
- Uses `RequestCallbackObserver` to drive `Loading / Success / ErrorState` flow
${hasCache ? '- ✅ **Local cache** is active (`readData` / `clearData`)' : '- ⬜ No local caching detected'}
${hasSave ? '- ✅ **Cache write-back** on success (`saveLocal`)' : ''}

---
''';
}

// ── UI ────────────────────────────────────────────────────────────────────────

String _buildUISection(String base, String featureName) {
  final pascal = toPascal(featureName);

  // Collect all UI sub-screens (directories inside ui/)
  final uiDir = Directory('$base/ui');
  if (!uiDir.existsSync()) {
    return '## 🖥️ UI Layer\n\n_No UI directory found._\n\n---\n';
  }

  final subScreens = uiDir
      .listSync()
      .whereType<Directory>()
      .map((d) => d.uri.pathSegments[d.uri.pathSegments.length - 2])
      .toList();

  final buffer = StringBuffer();
  buffer.writeln('## 🖥️ UI Layer\n');
  buffer.writeln('> **Overview**: Provides detailed breakdowns of each screen, injected dependencies, specific state listening logic, and atomic widgets.\n');

  for (final screen in subScreens) {
    final screenPascal = toPascal(screen);
    final screenDir = '$base/ui/$screen';
    final screenFile = '$screenDir/${screen}_screen.dart';
    final mixinFile = '$screenDir/${screen}_screen_mixin.dart';
    final widgetsDir = '$screenDir/widgets';

    final screenSrc = _read(screenFile);
    final mixinSrc = _read(mixinFile);

    // ── screen file summary ─────────────────────────────────────────────────

    // Check for BlocListener / BlocBuilder
    final hasBlocListener = screenSrc.contains('BlocListener');
    final hasBlocBuilder = screenSrc.contains('BlocBuilder');
    final hasAutoRoute = screenSrc.contains('@RoutePage') || screenSrc.contains('AutoRouteWrapper');
    final hasSemantics = screenSrc.contains('Semantics(');

    // Extract state listener specific details
    final listenerStatesRx = RegExp(r'if\s*\(\s*state\.(?:[a-zA-Z0-9_]+)\s+is\s+([a-zA-Z0-9_]+)\s*\)');
    final listenerStatesMatches = listenerStatesRx.allMatches(screenSrc);
    final listenedStates = listenerStatesMatches.map((m) => '`${m.group(1)}`').toSet().toList();
    final listenedStatesStr = listenedStates.isNotEmpty ? listenedStates.join(', ') : (hasBlocListener ? '_Listening to state changes_' : '—');

    // Extract Scaffold body content hint
    final scaffoldRx = RegExp(r'Scaffold\(([\s\S]*?)\)', multiLine: false);
    final scaffoldMatch = scaffoldRx.firstMatch(screenSrc);
    final scaffoldHint = scaffoldMatch != null
        ? (scaffoldMatch.group(1)!.contains('body:') ? '`Scaffold` has body defined' : '`Scaffold` present (no body yet)')
        : '`Scaffold` not directly visible or missing';

    // Extract args class (if any)
    final argsRx = RegExp(r'(\w+RouteArgs)\s+args');
    final argsMatch = argsRx.firstMatch(screenSrc);
    final argsClass = argsMatch?.group(1);

    buffer.writeln('### 📄 Screen: `$screen`\n');
    buffer.writeln('#### Main Screen File: `ui/$screen/${screen}_screen.dart`');
    buffer.writeln('| Aspect | Value |');
    buffer.writeln('|--------|-------|');
    buffer.writeln('| Class | `${screenPascal}Page extends StatefulWidget` |');
    buffer.writeln('| AutoRoute | ${hasAutoRoute ? '✅ `@RoutePage()` + `AutoRouteWrapper`' : '⬜ Not annotated'} |');
    if (argsClass != null) {
      buffer.writeln('| Route Args | `$argsClass` passed via constructor |');
    }
    buffer.writeln('| BlocListener | ${hasBlocListener ? '✅ Present' : '⬜ Not yet added'} |');
    buffer.writeln('| Listens to States | $listenedStatesStr |');
    buffer.writeln('| BlocBuilder | ${hasBlocBuilder ? '✅ Present' : '⬜ Not yet added'} |');
    buffer.writeln('| Semantics | ${hasSemantics ? '✅ Present' : '⚠️ Missing — required by design rules'} |');
    buffer.writeln('| Structure | $scaffoldHint |');
    buffer.writeln();

    // ── mixin / base state ──────────────────────────────────────────────────

    if (mixinSrc.isNotEmpty) {
      final initTodo = mixinSrc.contains('TODO') ? '⚠️ `initState` has TODO stubs' : '✅ `initState` implemented';
      buffer.writeln('#### Mixin / BaseState: `ui/$screen/${screen}_screen_mixin.dart`');
      buffer.writeln('''
| Aspect | Value |
|--------|-------|
| Class | `${screenPascal}PageBaseState extends State<${screenPascal}Page>` |
| Cubit access | `late final ${pascal.replaceAll(toPascal(screen), '')}${toPascal(featureName)}Cubit mainScreenCubit` |
| initState | $initTodo |
| dispose | Called via `super.dispose()` |
''');
    }

    // ── widgets ─────────────────────────────────────────────────────────────

    final widgetFiles = _dartFiles(widgetsDir);
    if (widgetFiles.isNotEmpty) {
      buffer.writeln('#### 🧱 Atomic Widgets (`ui/$screen/widgets/`)\n');
      buffer.writeln('Each extracted component below includes an **AI Usage Hint** mapping out how it should be used, what it expects, and specific design rules it follows.\n');

      for (final wf in widgetFiles) {
        final wName = wf.uri.pathSegments.last.replaceAll('.dart', '');
        final wPascal = toPascal(wName);
        final wSrc = wf.readAsStringSync();

        // Detect parent widget type
        final extendsRx = RegExp(r'class\s+\w+\s+extends\s+(\w+)');
        final extendsMatch = extendsRx.firstMatch(wSrc);
        final extendsType = extendsMatch?.group(1) ?? 'Widget';

        // Extract class properties / required data (e.g., final String title;)
        final propsRx = RegExp(r'final\s+([a-zA-Z0-9_<,>?]+)\s+([a-zA-Z0-9_]+)\s*;');
        final propsMatches = propsRx.allMatches(wSrc);
        final propsList = propsMatches.map((m) => '${m.group(1)} ${m.group(2)}').toList();
        final propsString = propsList.isNotEmpty ? propsList.map((p) => '`$p`').join(', ') : '_None_';

        // Detect child widgets used
        final childWidgetsRx = RegExp(r'\b(Column|Row|Stack|ListView|GridView|Container|Card|Text|Image|Icon|GestureDetector|InkWell|ElevatedButton|TextButton|Padding|SizedBox|Expanded|Flexible|Wrap|ClipRRect|DecoratedBox|AnimatedContainer|StreamBuilder|FutureBuilder)\b');
        final usedWidgets = childWidgetsRx
            .allMatches(wSrc)
            .map((m) => m.group(1)!)
            .toSet()
            .toList()
          ..sort();

        // Extract documentation comments above the class
        final docCommentRx = RegExp(r'(///.*\n)+\s*class\s+' + wPascal);
        final docMatch = docCommentRx.firstMatch(wSrc);
        String docString = '';
        if (docMatch != null) {
          docString = docMatch.group(0)!
              .split('\n')
              .where((l) => l.trim().startsWith('///'))
              .map((l) => l.trim().replaceFirst('///', '').trim())
              .join(' ');
        }

        final hasConst = wSrc.contains('const ');
        final hasSemantics = wSrc.contains('Semantics(');
        final hasBlocBuilder = wSrc.contains('BlocBuilder');
        final hasAppColors = wSrc.contains('AppColors');
        final hasAppTextStyles = wSrc.contains('AppTextStyles');
        final hasAppPadding = wSrc.contains('AppPadding') || wSrc.contains('AppSizes');
        final hasSpacingExt = wSrc.contains('verticalSpace') || wSrc.contains('horizontalSpace');

        // Write the widget readme block
        buffer.writeln('##### 🧩 `$wPascal` (`$wName.dart`)');
        if (docString.isNotEmpty) {
          buffer.writeln('> 💬 **Doc**: $docString\n');
        }
        buffer.writeln('- **Type**: `$wPascal extends $extendsType`');
        buffer.writeln('- **Constructor Props**: $propsString');
        buffer.writeln('- **Core Widgets Used**: ${usedWidgets.isNotEmpty ? usedWidgets.map((w) => '`$w`').join(', ') : '—'}');
        
        // Generate intelligent AI / Dev Hint
        buffer.writeln('\n**💡 AI / Dev Readme Hint:**');
        List<String> hints = [];
        
        if (propsList.isNotEmpty) {
           final names = propsMatches.map((m) => m.group(2)).join(", ");
           hints.add('**Injected Data**: Requires `$names`. Ensure the parent screen passes these arguments down.');
        } else {
           hints.add('**Static Component**: Layout-only widget with no required parameters. Safe to instantiate directly.');
        }
        
        if (hasBlocBuilder) {
           hints.add('**State**: Self-sufficient. It listens to Cubit states internally via `BlocBuilder`. Do not wrap this in another BlocBuilder externally unless necessary.');
        }
        
        if (!hasSemantics && (usedWidgets.contains('GestureDetector') || usedWidgets.contains('InkWell') || usedWidgets.contains('ElevatedButton'))) {
           hints.add('**⚠️ A11y Warning**: This widget appears interactive but lacks `Semantics`. Wrap it in a `Semantics` widget per design rules.');
        } else if (!hasSemantics) {
           hints.add('**A11y**: Lacks `Semantics`. Ensure the root of this widget tree is wrapped in `Semantics(label: ...)` if it conveys meaningful info.');
        } else {
           hints.add('**A11y**: ✅ Contains `Semantics` wrappers properly.');
        }

        if (!hasAppColors && !hasAppTextStyles && !hasAppPadding && !hasSpacingExt) {
          hints.add('**Styling**: Pure UI component. Relies entirely on inherited theme or does not specify project-standard styles.');
        } else {
          List<String> standards = [];
          if (hasAppColors) standards.add('AppColors');
          if (hasAppTextStyles) standards.add('AppTextStyles');
          if (hasAppPadding) standards.add('AppPadding');
          if (hasSpacingExt) standards.add('Spacing Extensions');
          hints.add('**Styling**: Uses standard project styling (`${standards.join(", ")}`).');
        }

        for (var hint in hints) {
          buffer.writeln('- $hint');
        }
        buffer.writeln('\n---\n');
      }
    } else {
      buffer.writeln('#### Widgets\n');
      buffer.writeln('_No widget files found yet in `ui/$screen/widgets/`._\n');
      buffer.writeln(
        '> **Reminder**: Per design rules, every distinct UI component must be extracted '
        'into a separate file inside `widgets/`.\n',
      );
    }
  }

  return buffer.toString();
}

// ── Design Checklist ──────────────────────────────────────────────────────────

String _buildChecklist(String featureName) {
  return '''
## ✅ AI Task Checklist (read before making changes)

Use this checklist before and after implementing any task in this feature:

- [ ] Route registered via `dart run lib/core/tools/create_auto_files/route_generator_data.dart`
- [ ] All strings use `'key'.tr()` (extracted via `generate_key.dart`)
- [ ] Colors → `AppColors` only
- [ ] Typography → `AppTextStyles` (+ `.copyWith()` for tweaks)
- [ ] Spacing → `n.verticalSpace` / `n.horizontalSpace` (no raw `SizedBox`)
- [ ] Padding → `AppPadding.pN` / `AppSizes.sN` constants
- [ ] Every root widget wrapped with `Semantics(label: '…')`
- [ ] All widgets use `const` constructors where possible
- [ ] Each `build()` ≤ 100 lines — extract if exceeded
- [ ] New widgets placed in `ui/$featureName/widgets/`
- [ ] Package imports only (no relative `../../` imports)
- [ ] `BlocListener` handles errors (SnackBar / Dialog)
- [ ] `CancelManager` keys added to `close()` in cubit

---

*Generated by `dart run lib/core/tools/mcp/feature_doc_generator.dart $featureName`*
''';
}

// ─── main ─────────────────────────────────────────────────────────────────────

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print('❌  No feature name provided.');
    print('Usage: dart run lib/core/tools/mcp/feature_doc_generator.dart <feature_name>');
    print('');
    print('Available features:');
    final screensDir = Directory('lib/features/screens');
    if (screensDir.existsSync()) {
      for (final d in screensDir.listSync().whereType<Directory>()) {
        final name = d.uri.pathSegments[d.uri.pathSegments.length - 2];
        print('  • $name');
      }
    }
    exit(1);
  }

  final featureName = args[0];
  final featureBase = 'lib/features/screens/$featureName';
  final outputDir = 'lib/core/ai_guide';
  final outputPath = '$outputDir/$featureName.md';

  // ── validate ────────────────────────────────────────────────────────────────
  if (!Directory(featureBase).existsSync()) {
    print('❌  Feature "$featureName" not found at $featureBase');
    print('');
    print('Available features:');
    final screensDir = Directory('lib/features/screens');
    if (screensDir.existsSync()) {
      for (final d in screensDir.listSync().whereType<Directory>()) {
        final name = d.uri.pathSegments[d.uri.pathSegments.length - 2];
        print('  • $name');
      }
    }
    exit(1);
  }

  print('🔍 Scanning feature: $featureName');
  print('   Base path : $featureBase');
  print('   Output    : $outputPath');
  print('');

  // ── generate sections ────────────────────────────────────────────────────────
  final sections = [
    _buildHeader(featureName),
    _buildControllerSection(featureBase, featureName),
    _buildDataSection(featureBase, featureName),
    _buildServiceSection(featureBase, featureName),
    _buildUISection(featureBase, featureName),
    _buildChecklist(featureName),
  ];

  String generatedContent = sections.join('\n');

  // ── preserve manual prompts ──────────────────────────────────────────────────
  const delimiter = '## ✍️ Custom Prompts & Notes';
  String manualContent = '''

$delimiter
> Add any manual hints, instructions, or specific feature rules here.
> Everything below this line is preserved automatically during regeneration.

''';

  final outFile = File(outputPath);
  if (outFile.existsSync()) {
    final existingText = outFile.readAsStringSync();
    if (existingText.contains(delimiter)) {
      manualContent = '\n$delimiter' + existingText.split(delimiter)[1];
    }
  }

  final finalContent = generatedContent + manualContent;

  // ── write output ─────────────────────────────────────────────────────────────
  Directory(outputDir).createSync(recursive: true);
  outFile.writeAsStringSync(finalContent);

  print('✅ Documentation generated → $outputPath');
  print('');
  print('💡 Tip: Open this file before starting any task on "$featureName".');
  print('   It saves token usage by giving the AI a precise feature map.');
}
