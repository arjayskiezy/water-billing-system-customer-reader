import 'package:flutter/material.dart';

class ForgotPasswordProvider extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  bool _mailSent = false;

  bool get mailSent => _mailSent;

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

    // Debug print the email
    debugPrint('Sending password reset link to: $email');

    // TODO: Replace this with actual API call to send email
    await Future.delayed(const Duration(seconds: 1));

    _mailSent = true;
    notifyListeners();
  }

  bool _validateEmail(String email) {
    return email.isNotEmpty && email.contains('@');
  }

  /// Reset the provider state
  void reset() {
    _mailSent = false;
    emailController.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
