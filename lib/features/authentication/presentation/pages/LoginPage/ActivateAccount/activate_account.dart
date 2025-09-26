import 'package:flutter/material.dart';

class ActivateAccountPage extends StatefulWidget {
  const ActivateAccountPage({super.key});

  @override
  State<ActivateAccountPage> createState() => _ActivateAccountPageState();
}

class _ActivateAccountPageState extends State<ActivateAccountPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _meterController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _activationSent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _accountController.dispose();
    _meterController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _requestActivation() {
    String accountNumber = _accountController.text.trim();
    String meterNumber = _meterController.text.trim();
    String password = _passwordController.text.trim();

    if (accountNumber.isEmpty || meterNumber.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate activation API call
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
        _activationSent = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 440),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: _activationSent
                  ? _buildActivationSent(colors)
                  : _buildForm(colors),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(ColorScheme colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 120,
          height: 120,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 24),
        Text(
          "Activate Your Account",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Please provide the details for your account.",
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 32),
        // Account Number
        TextField(
          controller: _accountController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Account Number',
            prefixIcon: Icon(Icons.account_circle, color: colors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.primary),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Meter Number
        TextField(
          controller: _meterController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Meter Number',
            prefixIcon: Icon(Icons.confirmation_number, color: colors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.primary),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Password
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock, color: colors.primary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colors.primary),
            ),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _requestActivation,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Request Activation",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Back to Login',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildActivationSent(ColorScheme colors) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/undraw_Mail_sent_re_0ofv.png',
          width: 180,
          height: 180,
        ),
        const SizedBox(height: 24),
        Text(
          "Activation Request Sent!",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "We've sent your activation request. You can now go back to login.",
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            child: Text(
              "Back to Login",
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ),
      ],
    );
  }
}
