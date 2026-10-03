import 'package:flutter/material.dart';

class C {
  static const bg = Color(0xFF000000);
  static const card = Color(0xFF000000);
  static const line = Color(0xFF262626);
  static const text = Color(0xFFFAFAFA);
  static const muted = Color(0xFFA8A8A8);
  static const accent = Color(0xFF0095F6);
  static const story = [Color(0xFFFEDA75), Color(0xFFFA7E1E), Color(0xFFD62976), Color(0xFF962FBF)];
}

ThemeData clougoTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: C.bg,
    fontFamily: 'Roboto',
    colorScheme: const ColorScheme.dark(primary: C.accent, surface: C.bg),
    appBarTheme: const AppBarTheme(
      backgroundColor: C.bg,
      foregroundColor: C.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: C.text, letterSpacing: -0.4),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: C.bg,
      height: 56,
      indicatorColor: Colors.transparent,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      iconTheme: WidgetStateProperty.resolveWith((s) => IconThemeData(
        color: s.contains(WidgetState.selected) ? Colors.white : Colors.white,
        size: 26,
      )),
    ),
    dividerColor: C.line,
  );
}
