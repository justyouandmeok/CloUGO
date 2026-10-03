import 'package:flutter/material.dart';

class C {
  static const bg = Color(0xFF0B0B0F);
  static const card = Color(0xFF16161D);
  static const line = Color(0xFF2A2A34);
  static const text = Color(0xFFF4F4F8);
  static const muted = Color(0xFF9A9AA8);
  static const accent = Color(0xFF7C5CFF);
  static const accent2 = Color(0xFF3EE0C5);
}

ThemeData clougoTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: C.bg,
    colorScheme: const ColorScheme.dark(primary: C.accent, surface: C.card),
    appBarTheme: const AppBarTheme(backgroundColor: C.bg, foregroundColor: C.text, elevation: 0),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: C.card,
      indicatorColor: C.accent.withValues(alpha: 0.25),
      labelTextStyle: WidgetStateProperty.all(const TextStyle(fontSize: 11)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: C.card,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
    ),
  );
}
