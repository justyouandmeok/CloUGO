import 'package:flutter/material.dart';

class C {
  static const bg = Color(0xFF0B1220);
  static const card = Color(0xFF152033);
  static const line = Color(0xFF243044);
  static const text = Color(0xFFF4F7FB);
  static const muted = Color(0xFF93A0B5);
  static const accent = Color(0xFF5B8CFF);
  static const accent2 = Color(0xFF7C5CFF);
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
      indicatorColor: C.accent.withValues(alpha: 0.22),
      labelTextStyle: WidgetStateProperty.all(const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
    ),
  );
}
