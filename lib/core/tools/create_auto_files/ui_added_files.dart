import 'dart:io';
import '../create_auto_files/path_constants.dart';
import 'path_constants.dart';
import 'path_constants.dart';
class UIAddRequiredFiles extends BaseAddRequiredFiles {
  UIAddRequiredFiles({required this.screenFileName, required this.screenName, required this.secondaryName});

  final String screenFileName, screenName, secondaryName;

  @override
  makeRequiredFiles(String folder) async {
    super.makeRequiredFiles(folder);

    // 1. Create a named subfolder inside waste_calculator/ e.g. waste_calculator/project_details/
    final screenDir = Directory(
      '${PathConstants().folderPath(folder)}/$secondaryName',
    );
    if (!screenDir.existsSync()) {
      screenDir.createSync(recursive: true);
      print('📁 Created screen folder: ${screenDir.path}');
    }

    // 2. Create the main screen file inside that subfolder
    final screenFile = File('${screenDir.path}/$screenFileName');
    if (!screenFile.existsSync()) {
      final String notifierClassInstant = PathConstants()
          .tolowerCasTheFirstCharachter(PathConstants().notifierName());
      screenFile.writeAsStringSync(
          _getScreenContent(screenName, notifierClassInstant, secondaryName));
      print('📄 Created screen file: ${screenFile.path}');
    }

    // 3. Create the mixin file (BaseState) inside the same subfolder
    final mixinFileName = '${secondaryName}_screen_mixin.dart';
    final mixinFile = File('${screenDir.path}/$mixinFileName');
    if (!mixinFile.existsSync()) {
      mixinFile.writeAsStringSync(
          _getMixinContent(screenName, secondaryName));
      print('📄 Created mixin file: ${mixinFile.path}');
    }

    // 4. Create the widgets/ folder inside the screen subfolder
    final widgetsDir = Directory('${screenDir.path}/widgets');
    if (!widgetsDir.existsSync()) {
      widgetsDir.createSync(recursive: true);
      print('📁 Created widgets folder: ${widgetsDir.path}');
    }
  }
}

// ─── Screen file content ──────────────────────────────────────────────────────

String _getScreenContent(String widgetName, String notifierClassInstant, String secondaryName) {
  final mixinFileName = '${secondaryName}_screen_mixin.dart';
  return '''import 'package:${PathConstants().projectName}/core/app/route.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:${PathConstants().projectName}/core/constants/app_locator.dart';
import 'package:${PathConstants().projectName}/features/screens/${PathConstants().name}/controller/${PathConstants().cubitFileName()}';
 
part '$mixinFileName';

@RoutePage()
class $widgetName extends StatefulWidget implements AutoRouteWrapper {
  const $widgetName({super.key, required this.args});
  final ${widgetName.replaceAll('Page', 'RouteArgs')} args;

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider<${PathConstants().cubitName()}>(
      create: (context) =>  AppLocator()()() ,
      child: this,
    );
  }

  @override
  State<$widgetName> createState() => _${widgetName}State();
}

class _${widgetName}State extends ${widgetName}BaseState {
  @override
  Widget build(BuildContext context) {
    return BlocListener<${PathConstants().cubitName()}, ${PathConstants().stateName()}>(
      listener: (context, state) {
        // TODO: implement listener
      },
      child: Scaffold(

      ),
    );
  }
}
''';
}

// ─── Mixin file content ───────────────────────────────────────────────────────

String _getMixinContent(String widgetName, String secondaryName) {
  final screenFileName = '${secondaryName}_screen.dart';
  return '''part of '$screenFileName';

abstract class ${widgetName}BaseState extends State<$widgetName> {
  late final ${PathConstants().cubitName()} ${PathConstants().tolowerCasTheFirstCharachter(PathConstants().cubitName())};

  @override
  void initState() {
    ${PathConstants().tolowerCasTheFirstCharachter(PathConstants().cubitName())} = ${PathConstants().cubitName()}.get(context: context);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
''';
}
