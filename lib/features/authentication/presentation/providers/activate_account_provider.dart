import 'package:flutter/material.dart';

class ActivateAccountProvider extends ChangeNotifier {
  // Controllers
  final TextEditingController accountController = TextEditingController();
  final TextEditingController meterController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // State
  bool _activationSent = false;
  bool _isLoading = false;

  bool get activationSent => _activationSent;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    accountController.dispose();
    meterController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Reset provider state
  void reset() {
    accountController.clear();
    meterController.clear();
    passwordController.clear();
    _activationSent = false;
    _isLoading = false;
    notifyListeners();
  }

  /// Request account activation
  Future<void> requestActivation(BuildContext context) async {
    final accountNumber = accountController.text.trim();
    final meterNumber = meterController.text.trim();
    final password = passwordController.text.trim();

    if (accountNumber.isEmpty || meterNumber.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    // Debug print inputs
    debugPrint(
      '🔑 Activation request: account=$accountNumber, meter=$meterNumber, password=$password',
    );

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    _activationSent = true;
    notifyListeners();

    debugPrint('✅ Activation request sent successfully');
  }
}
