import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newf/core/app/route.dart';
import 'package:newf/core/storage/hive_storage.dart';
import 'package:newf/core/theming/app_theme.dart';
import 'package:newf/core/theming/theme_cubit.dart';
import 'package:newf/main.dart';

final appRouter = AppRouter(navigatorKey: navigatorKey);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    // TODO: implement dispose
    HiveStorage().closeBox();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeCubit>().state;
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      key: Key(context.locale.languageCode),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'newf',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(0.8),
          ),
          child: child!,
        );
      },
      routerConfig: appRouter.config(),
    );
  }
}