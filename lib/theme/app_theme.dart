import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const background = Color(0xFF0B0E14);
  static const surface = Color(0xFF1A1D22);
  static const green = Color(0xFF00F58A);
  static const cyan = Color(0xFF26E4FF);
  static const white = Color(0xFFEFFFF0);
  static const muted = Color(0xFFB6C5B6);
  static const border = Color(0xFF343A3E);

  static TextStyle heading(double size) => TextStyle(
    fontFamily: 'Syne',
    fontSize: size,
    fontWeight: FontWeight.w700,
    height: 1.08,
    letterSpacing: -0.7,
    color: white,
  );

  static TextStyle mono({double size = 11, Color color = muted}) => TextStyle(
    fontFamily: 'SpaceMono',
    fontSize: size,
    letterSpacing: 1,
    height: 1.4,
    color: color,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    fontFamily: 'Outfit',
    colorScheme: const ColorScheme.dark(
      primary: green,
      onPrimary: Color(0xFF002414),
      secondary: cyan,
      surface: surface,
      onSurface: white,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 17, height: 1.5, color: muted),
      bodyMedium: TextStyle(fontSize: 15, height: 1.4, color: muted),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: surface,
      contentTextStyle: const TextStyle(fontFamily: 'Outfit', color: white),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
