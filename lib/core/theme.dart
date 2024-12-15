import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = _lightMode;
  get themeData => _themeData;

  void toggleMode() {
    _themeData = _themeData == _lightMode ? _darkMode : _lightMode;
    notifyListeners();
  }

  void setLight() {
    _themeData = _lightMode;
    notifyListeners();
  }

  static const Color darkBack = Color(0xFF323842);
  static const Color darkMain = Color.fromARGB(255, 217, 78, 122);
  static const Color darkSec = Color(0xFF73b5e7);

  static const Color lightBack = Color(0xFFf6f2e1);
  static const Color lightMain = Color(0xFF81b07a);
  static const Color lightSec = Color(0xFFfcb040);

  static final ThemeData _lightMode = ThemeData(
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: lightSec,
    ),
    colorScheme:
        const ColorScheme.light(primary: lightMain, secondary: lightSec),
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
    scaffoldBackgroundColor: lightBack,
    textTheme: GoogleFonts.ubuntuTextTheme(const TextTheme(
        bodyMedium: TextStyle(color: Colors.black),
        bodySmall: TextStyle(color: Colors.black))),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap)),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(20))),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: lightMain,
            foregroundColor: Colors.black)),
  );

  static final ThemeData _darkMode = ThemeData(
    snackBarTheme: const SnackBarThemeData(backgroundColor: darkSec),
    colorScheme: const ColorScheme.dark(primary: darkMain, secondary: darkSec),
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
    scaffoldBackgroundColor: darkBack,
    textTheme: GoogleFonts.ubuntuTextTheme(const TextTheme(
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white))),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap)),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.black,
      hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(20))),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            backgroundColor: darkMain,
            foregroundColor: Colors.white)),
  );
}
