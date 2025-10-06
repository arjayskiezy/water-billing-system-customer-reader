import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presentation/providers/auth_provider.dart';
import '../presentation/pages/HomePage/home_page.dart';
import '../presentation/pages/LoginPage/login_page.dart';
import '../presentation/pages/HomePageReader/reader_dashboard.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (authProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!authProvider.loggedIn) {
      return const LoginPage();
    }

    switch (authProvider.role) {
      case UserRole.customer:
        return const DashboardPage();
      case UserRole.reader:
        return const ReaderDashboardPage();
      default:
        return const LoginPage();
    }
  }
}
