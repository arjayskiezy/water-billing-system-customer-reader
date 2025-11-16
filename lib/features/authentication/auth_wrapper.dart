import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/LoginProvider/auth_provider.dart';
import '../presentation/HomePageCustomer/customer_dashboard.dart';
import '../presentation/LoginPage/login_page.dart';
import '../presentation/HomePageReader/reader_dashboard.dart';

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
