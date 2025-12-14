import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'features/authentication/auth_wrapper.dart';
import 'features/theme/theme.dart';
import 'features/providers/LoginProvider/auth_provider.dart';
import 'features/providers/LoginProvider/water_application_provider.dart';
import 'features/providers/CustomerProviders/billing_history&usage_provider.dart';
import 'features/providers/CustomerProviders/billing_history_page_provider.dart';
import 'features/providers/CustomerProviders/billing_usage_page_provider.dart';
import 'features/providers/CustomerProviders/announcement_provider.dart';
import 'features/providers/CustomerProviders/report_issue_provider.dart';
import 'features/providers/ReaderProviders/reader_dashboard_provider.dart';
import 'features/providers/ReaderProviders/assigned_area_provider.dart';
import 'features/providers/ReaderProviders/input_readings_provider.dart';
import 'features/providers/ReaderProviders/settings_profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(); 

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..loadUser()),
        ChangeNotifierProvider(create: (_) => WaterApplicationProvider()),
        ChangeNotifierProvider(create: (_) => BillingProvider()),
        ChangeNotifierProvider(create: (_) => BillingHistoryProvider()),
        ChangeNotifierProvider(create: (_) => BillBreakdownProvider()),
        ChangeNotifierProvider(create: (_) => AnnouncementProvider()),
        ChangeNotifierProvider(create: (_) => ReaderDashboardProvider()),
        ChangeNotifierProvider(create: (_) => AssignedAreaProvider()),
        ChangeNotifierProvider(create: (_) => WaterReadingProvider()),
        ChangeNotifierProvider(create: (_) => StorageProvider()),
        ChangeNotifierProvider(create: (_) => ReportIssueProvider()),
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
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}
