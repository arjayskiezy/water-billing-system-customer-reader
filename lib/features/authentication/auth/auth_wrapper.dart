import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/pages/HomePage/home_page.dart';
import '../presentation/pages/LoginPage/login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.loggedIn) {
      return const DashboardPage();
    } else {
      return const LoginPage();
    }
  }
}
