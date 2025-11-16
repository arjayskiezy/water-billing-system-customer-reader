import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF00539A),
        primary: const Color(0xFF00539A),
        secondary: const Color(0xFF006ECE),
        tertiary: const Color(0xFF57636C),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF00539A),
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF00539A),
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF00539A),
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF00539A),
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF57636C),
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF57636C),
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF57636C),
        ),
        bodyLarge: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF333333),
        ),
        bodyMedium: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF333333),
        ),
        bodySmall: GoogleFonts.roboto(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF666666),
        ),
        labelLarge: GoogleFonts.roboto(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF00539A),
        ),
        labelMedium: GoogleFonts.roboto(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF00539A),
        ),
        labelSmall: GoogleFonts.roboto(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF00539A),
        ),
      ),
      useMaterial3: true,
    );
  }
}
