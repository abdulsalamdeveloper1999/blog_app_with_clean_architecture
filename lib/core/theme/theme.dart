import 'package:blog_clean_architecture/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border({
    Color color = AppPallete.borderColor,
  }) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
      );

  static final darkTheme = ThemeData.dark().copyWith(
    appBarTheme: const AppBarTheme(backgroundColor: AppPallete.backgroundColor),
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      focusedBorder: _border(color: AppPallete.gradient2),
      enabledBorder: _border(),
      errorBorder: _border(color: Colors.red),
      border: _border(),
    ),
    chipTheme: const ChipThemeData(
      color: MaterialStatePropertyAll(AppPallete.backgroundColor),
    ),
  );
}
