import 'package:flutter/material.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  bool _mailSent = false;
  bool _isLoading = false; // <-- Added this field

  bool get mailSent => _mailSent;
  bool get isLoading => _isLoading; // <-- Added getter

  /// Attempt to send the password reset link
  Future<void> sendResetLink(BuildContext context) async {
    final email = emailController.text.trim();

    if (!_validateEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email to continue.'),
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    _setLoading(true); // <-- Start loading
    debugPrint('Sending password reset link to: $email');

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    _mailSent = true;
    _setLoading(false); // <-- Stop loading
    notifyListeners();
  }

  bool _validateEmail(String email) {
    return email.isNotEmpty && email.contains('@');
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Reset the provider state
  void reset() {
    _mailSent = false;
    _isLoading = false;
    emailController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
