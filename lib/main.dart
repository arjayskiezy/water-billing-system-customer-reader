import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/authentication/presentation/providers/auth_provider.dart';
import 'features/authentication/presentation/pages/login_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waterworks Digital Billing System',
      themeMode: ThemeMode.system,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
    );
  }
}
