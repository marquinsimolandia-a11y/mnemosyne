import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Color Palette ──────────────────────────────────────────────────────────
  static const Color neonCyan = Color(0xFF00F5FF);
  static const Color neonPurple = Color(0xFFBF00FF);
  static const Color neonGreen = Color(0xFF00FF88);
  static const Color background = Color(0xFF0A0A0F);
  static const Color surfaceDark = Color(0xFF0F0F1A);
  static const Color glassCard = Color(0x14FFFFFF);
  static const Color glassCardBorder = Color(0x33FFFFFF);
  static const Color textPrimary = Color(0xFFE0E0FF);
  static const Color textSecondary = Color(0xFF8888AA);
  static const Color userBubble = Color(0x2200F5FF);
  static const Color mnemosyneBubble = Color(0x22BF00FF);
  static const Color error = Color(0xFFFF4444);

  // ── Glow Shadow Helpers ────────────────────────────────────────────────────
  static List<BoxShadow> cyanGlow({double blurRadius = 24, double spread = 0}) =>
      [BoxShadow(color: neonCyan.withValues(alpha: 0.55), blurRadius: blurRadius, spreadRadius: spread)];

  static List<BoxShadow> purpleGlow({double blurRadius = 24, double spread = 0}) =>
      [BoxShadow(color: neonPurple.withValues(alpha: 0.55), blurRadius: blurRadius, spreadRadius: spread)];

  static List<BoxShadow> greenGlow({double blurRadius = 20, double spread = 0}) =>
      [BoxShadow(color: neonGreen.withValues(alpha: 0.55), blurRadius: blurRadius, spreadRadius: spread)];

  // ── Border ─────────────────────────────────────────────────────────────────
  static Border cyanBorder({double width = 1.0}) =>
      Border.all(color: neonCyan.withValues(alpha: 0.4), width: width);

  static Border purpleBorder({double width = 1.0}) =>
      Border.all(color: neonPurple.withValues(alpha: 0.4), width: width);

  // ── Gradient ───────────────────────────────────────────────────────────────
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A0A0F), Color(0xFF0E0A1A), Color(0xFF0A0E1A)],
  );

  static const LinearGradient cyanPurpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonCyan, neonPurple],
  );

  // ── Theme Data ─────────────────────────────────────────────────────────────
  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.dark(
          primary: neonCyan,
          secondary: neonPurple,
          surface: surfaceDark,
          error: error,
        ),
        textTheme: GoogleFonts.exo2TextTheme(
          const TextTheme(
            displayLarge: TextStyle(color: textPrimary),
            displayMedium: TextStyle(color: textPrimary),
            bodyLarge: TextStyle(color: textPrimary),
            bodyMedium: TextStyle(color: textPrimary),
            bodySmall: TextStyle(color: textSecondary),
          ),
        ),
        iconTheme: const IconThemeData(color: neonCyan),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: GoogleFonts.orbitron(
            color: neonCyan,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
          iconTheme: const IconThemeData(color: neonCyan),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: glassCard,
          hintStyle: const TextStyle(color: textSecondary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: neonCyan.withValues(alpha: 0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: neonCyan.withValues(alpha: 0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: neonCyan, width: 1.5),
          ),
        ),
        useMaterial3: true,
      );
}
