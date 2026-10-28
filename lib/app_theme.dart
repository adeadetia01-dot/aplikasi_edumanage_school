// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

// ── Colour Palette ──────────────────────────────────────────────────────────
const Color kGreen = Color(0xFF087653);
const Color kDark  = Color(0xFF04583F);
const Color kMint  = Color(0xFFD8FBEC);
// Page background – matches the phone canvas of the wireframe (.phone background)
const Color kBg    = Color(0xFFF7F8FA);
const Color kInk   = Color(0xFF1C292E);
const Color kMuted = Color(0xFF728087);
const Color kBlue  = Color(0xFF3F81EE);
const Color kAmber = Color(0xFFDF9C2D);
const Color kRed   = Color(0xFFD65353);
const Color kLine  = Color(0xFFDFE5E8);
const Color kWhite = Color(0xFFFFFFFF);

// ── Theme ────────────────────────────────────────────────────────────────────
abstract class AppTheme {
  static ThemeData theme() {
    return ThemeData(
      useMaterial3: false,
      primaryColor: kGreen,
      scaffoldBackgroundColor: kBg,
      colorScheme: ColorScheme.light(
        primary: kGreen,
        secondary: kDark,
        background: kBg,
        surface: kWhite,
        onPrimary: kWhite,
        onSecondary: kWhite,
        onBackground: kInk,
        onSurface: kInk,
        error: kRed,
        onError: kWhite,
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: kWhite,
        foregroundColor: kInk,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: kInk,
        ),
        iconTheme: IconThemeData(color: kInk),
        shape: Border(
          // wireframe: .app-header → border-bottom 1px solid #edf0f1
          bottom: BorderSide(color: Color(0xFFEDF0F1), width: 1),
        ),
      ),

      // Bottom Nav – wireframe: .bottom / .tab / .tab.sel
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kWhite,
        selectedItemColor: kGreen,
        unselectedItemColor: Color(0xFF929D9D),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // Cards – wireframe: .card { border 1px #e8eded, radius 12 }
      cardTheme: CardThemeData(
        color: kWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE8EDED), width: 1),
        ),
      ),

      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: kLine),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: kLine),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: kGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: kRed),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: const BorderSide(color: kRed, width: 1.5),
        ),
        hintStyle: const TextStyle(color: kMuted, fontSize: 14),
        labelStyle: const TextStyle(color: kMuted, fontSize: 14),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kGreen,
          foregroundColor: kWhite,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: kLine,
        thickness: 1,
        space: 1,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Inter', color: kInk),
        displayMedium: TextStyle(fontFamily: 'Inter', color: kInk),
        displaySmall: TextStyle(fontFamily: 'Inter', color: kInk),
        headlineLarge: TextStyle(fontFamily: 'Inter', color: kInk),
        headlineMedium: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700, color: kInk),
        headlineSmall: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, color: kInk),
        titleLarge: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 18, color: kInk),
        titleMedium: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 16, color: kInk),
        titleSmall: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w500, fontSize: 14, color: kInk),
        bodyLarge: TextStyle(fontFamily: 'Inter', fontSize: 15, color: kInk),
        bodyMedium: TextStyle(fontFamily: 'Inter', fontSize: 14, color: kInk),
        bodySmall: TextStyle(fontFamily: 'Inter', fontSize: 12, color: kMuted),
        labelLarge: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600, fontSize: 15, color: kInk),
        labelMedium: TextStyle(fontFamily: 'Inter', fontSize: 12, color: kMuted),
        labelSmall: TextStyle(fontFamily: 'Inter', fontSize: 10, letterSpacing: 0.8, color: kMuted),
      ),
    );
  }
}
