

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:newf/core/constants/app_locator.dart';
 import 'package:newf/core/internet/offline_sync_service.dart';
import 'package:newf/core/localization/localization.dart';
import 'package:newf/core/storage/hive_storage.dart';
import 'package:newf/core/theming/theme_cubit.dart';

import 'core/app/app.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: 'Main Navigator');
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveStorage().init();
  await EasyLocalization.ensureInitialized();
  await CodegenLoader.init();
  AppLocator().init();

  runApp(
    BlocProvider<ThemeCubit>(
      create: (context) => AppLocator()()(),
      child: EasyLocalization(
        supportedLocales: CodegenLoader.supportedLocales,
        fallbackLocale: CodegenLoader.fallBackLocale,
        path: CodegenLoader.assetTranslationsPath,
        assetLoader: CodegenLoader(),
        child: const MyApp(),
      ),
    ),
  );
}


// //flutter pub run custom_lint