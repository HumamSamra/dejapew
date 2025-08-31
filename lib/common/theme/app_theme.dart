import 'package:dejapew/common/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
    fontFamily: 'Lalezar',
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    splashFactory: NoSplash.splashFactory,
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(enableFeedback: false),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(enableFeedback: false),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(enableFeedback: false),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(enableFeedback: false),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(enableFeedback: false),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
