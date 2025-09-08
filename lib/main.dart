import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/authentication/presentation/providers/auth_provider.dart';
import 'features/authentication/auth/auth_wrapper.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider()..loadUser(),
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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthWrapper(),
    );
  }
}
