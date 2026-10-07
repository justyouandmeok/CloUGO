import 'package:flutter/material.dart';

class C {
  static const bg = Color(0xFF000000);
  static const field = Color(0xFF121212);
  static const line = Color(0xFF262626);
  static const text = Color(0xFFFAFAFA);
  static const muted = Color(0xFFA8A8A8);
  static const blue = Color(0xFF0095F6);
  static const accent = blue;
  static const card = Color(0xFF000000);
  static const story = [Color(0xFFFEDA75), Color(0xFFFA7E1E), Color(0xFFD62976), Color(0xFF962FBF), Color(0xFF4F5BD5)];
}

ThemeData clougoTheme() {
  const text = TextStyle(color: C.text, fontSize: 14, height: 1.25);
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: C.bg,
    colorScheme: const ColorScheme.dark(primary: C.blue, surface: C.bg),
    textTheme: const TextTheme(bodyMedium: text, bodyLarge: text, titleMedium: TextStyle(color: C.text, fontSize: 16, fontWeight: FontWeight.w600)),
    appBarTheme: const AppBarTheme(
      backgroundColor: C.bg,
      foregroundColor: C.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      toolbarHeight: 48,
      titleTextStyle: TextStyle(color: C.text, fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.4),
    ),
    iconTheme: const IconThemeData(color: C.text, size: 24),
    dividerColor: C.line,
    listTileTheme: const ListTileThemeData(iconColor: C.text, textColor: C.text),
    filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(
      backgroundColor: C.blue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      minimumSize: const Size.fromHeight(44),
      textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
      foregroundColor: C.text,
      side: const BorderSide(color: C.line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      minimumSize: const Size.fromHeight(32),
      textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
    )),
  );
}
