import 'package:flutter/material.dart';
import 'package:newf/core/theming/app_colors.dart';

class AppTheme {
  AppTheme._();

  // Light ThemeData
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness:  .light,
       primaryColor: AppColors.primaryLightColor,
      canvasColor:AppColors.lightBorder ,
      scaffoldBackgroundColor: AppColors.lightBackground,
      colorScheme: const  .light(
        primary: AppColors.primaryLightColor,
        secondary: AppColors.secondryLightColor,
        surface:AppColors. lightSurface,
        error:AppColors.red ,
        onPrimary: AppColors.green,
        // onSecondary: Colors.white,
        tertiaryFixed: AppColors.lightTextPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primaryLightColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: .new(
        color: AppColors.lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:  .circular(12),
          side: const BorderSide(color: AppColors.lightBorder),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.lightBorder,
        thickness: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor:  .resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primaryLightColor;
          return null;
        }),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: AppColors.lightTextPrimary, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color:AppColors. lightTextPrimary),
        bodyMedium: TextStyle(color: AppColors.lightTextSecondary),
      ),
    );
  }



  // Dark ThemeData
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness:  .dark,
      primaryColor: AppColors.primaryDarkColor,

      scaffoldBackgroundColor:AppColors. darkBackground,
      colorScheme:    .dark(
        primary: AppColors.primaryDarkColor,
        secondary: AppColors.secondryDarkColor,
        surface: AppColors.darkSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: .new(
        color: AppColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:  .circular(12),
          side: const BorderSide(color: AppColors.darkBorder),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.darkBorder,
        thickness: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor:  .resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primaryDarkColor;
          return null;
        }),
        trackColor:  .resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primaryDarkColor.withOpacity(0.5);
          return null;
        }),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: AppColors.darkTextPrimary, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(color: AppColors.darkTextPrimary),
        bodyMedium: TextStyle(color:AppColors. darkTextSecondary),
      ),
    );
  }
}
