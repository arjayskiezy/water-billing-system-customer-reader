import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/authentication/presentation/providers/AuthProvider/auth_provider.dart';
import 'features/authentication/auth/auth_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/authentication/presentation/providers/AuthProvider/water_application_provider.dart';
import 'features/authentication/presentation/providers/CustomerProviders/billing_history&usage_provider.dart';
import 'features/authentication/presentation/providers/CustomerProviders/billing_history_page_provider.dart';
import 'features/authentication/presentation/providers/CustomerProviders/billing_usage_page_provider.dart';
import 'features/authentication/presentation/providers/CustomerProviders/announcement_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadUser()),
        ChangeNotifierProvider(create: (_) => WaterApplicationProvider()),
        ChangeNotifierProvider(create: (_) => BillingProvider()),
        ChangeNotifierProvider(create: (_) => BillingHistoryProvider()),
        ChangeNotifierProvider(create: (_) => BillBreakdownProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waterworks Billing',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00539A), // Primary color
          primary: const Color(0xFF00539A), // Explicit primary
          secondary: const Color(0xFF006ECE), // Secondary color
          tertiary: const Color(0xFF57636C),
        ),
        textTheme: TextTheme(
          // Headlines
          displayLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF00539A), // Primary
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

          // Titles
          titleLarge: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF57636C), // Tertiary
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

          // Body
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

          // Labels & Buttons
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

        useMaterial3: true, // optional but recommended
      ),
      home: const AuthWrapper(),
    );
  }
}
