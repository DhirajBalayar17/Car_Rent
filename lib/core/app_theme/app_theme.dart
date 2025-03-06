import 'package:flutter/material.dart';
// import 'package:my_new/flutter/bin/cache/pkg/sky_engine/lib/ui/ui.dart';
// import 'package:my_new/flutter/packages/flutter/lib/material.dart';

class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  static ThemeData getApplicationTheme({required bool isDark}) {
    return ThemeData(
      primarySwatch: Colors.orange,
      fontFamily: 'Montserrat',
      scaffoldBackgroundColor: Colors.orange[50],

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.orangeAccent[100],
        elevation: 0, // Removes shadow
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.amber,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
      ),

      // Text Theme
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
        titleLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.orangeAccent,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: Colors.white,
        shadowColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }
}
