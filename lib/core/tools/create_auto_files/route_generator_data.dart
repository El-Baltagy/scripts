import 'dart:convert';
import 'dart:io';
import '../create_auto_files/path_constants.dart';
import 'path_constants.dart';



Future<void> addAutoRoute(String routeName,String screenFileName) async {
   final routeFile = File(PathConstants().appRoutePath());
  if (!routeFile.existsSync()) {
    routeFile.createSync(recursive: true);
     routeFile.writeAsStringSync(_routeFileData);
  }
   final routeGenFile = File(PathConstants().routeGenPath());
   if (!routeGenFile.existsSync()) {
     routeGenFile.createSync(recursive: true);
     routeGenFile.writeAsStringSync(_routeFileGenData);
   }

  final String content = await routeFile.readAsString();
  String updatedText = content;

  if (content.contains('${routeName}.page')) {
    print('Route $routeName already exists. Skipping.');
    return;
  }

  String importStr = "import 'package:${PathConstants().projectName}/features/screens/${PathConstants().name}/ui/${screenFileName.replaceAll('_screen.dart', '')}/$screenFileName';";
  if (!content.contains(importStr)) {
    updatedText = updatedText.replaceFirst(
      "part",
      "$importStr\npart",
    );
  }

  String routeStr = '''
      AutoRoute(
        page: ${routeName}.page,
        // initial: true,
      ),''';

  updatedText = updatedText.replaceFirst(
    "List<AutoRoute> get routes => [",
    "List<AutoRoute> get routes => [\n$routeStr"
  );

  routeFile.writeAsStringSync(updatedText);

  // Automatically update route.gr.dart
  final String screenName = routeName.replaceAll('Route', 'Page');
  final String argsName = routeName + 'Args';
  final String grFilePath = PathConstants().routeGenPath();
  final File grFile = File(grFilePath);
  
  if (grFile.existsSync()) {
    String grContent = await grFile.readAsString();
    
    String pagesMapEntry = '''
    $routeName.name: (routeData) {
      final args = routeData.argsAs<$argsName>(orElse: () =>   $argsName.noArgs());
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: WrappedRoute(
            child: $screenName(
           args: args ,
        )),
      );
    },''';
    
    if (!grContent.contains('$routeName.name:')) {
      grContent = grContent.replaceFirst(
        'final Map<String, PageFactory> pagesMap = {',
        'final Map<String, PageFactory> pagesMap = {\n$pagesMapEntry'
      );
    }
    
    String routeClass = '''

/// generated route for
/// [$screenName]
class $routeName extends PageRouteInfo<$argsName> {
  $routeName({
   required $argsName args  ,
    List<PageRouteInfo>? children,
  }) : super(
    $routeName.name,
    args: args,
    initialChildren: children,
  );

  static const String name = '$routeName';

  static const PageInfo<$argsName> page =
  PageInfo<$argsName>(name);
}
class $argsName {
  const $argsName( );
   static $argsName noArgs()=>$argsName();
}
''';
    
    if (!grContent.contains('class $routeName extends PageRouteInfo')) {
      grContent = grContent + routeClass;
    }
    
    grFile.writeAsStringSync(grContent);
  }
}

final String _routeFileData =
'''
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' ;
part  '${PathConstants().appRouteName}.gr.dart';

@AutoRouterConfig(replaceInRouteName: '${PathConstants().screenSuffixTxt},${PathConstants().pathRouteSuffix}')
class AppRouter extends _\$AppRouter {
  AppRouter({super.navigatorKey});

  @override
  List<AutoRoute> get routes => [
     
  ];
}
// class AuthGuard extends AutoRouteGuard {
//   @override
//   void onNavigation(NavigationResolver resolver, StackRouter router) {
//     final isLoggedIn = false; // check your auth state
//     if (isLoggedIn) {
//       resolver.next(true);
//     } else {
//       router.replace(const AuthRoute());
//     }
//   }
// }
      ''';

final String _routeFileGenData =
'''
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'route.dart';

abstract class _\$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _\$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
 
  };
}
''';
