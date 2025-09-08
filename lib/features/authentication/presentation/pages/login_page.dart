import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _meterNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (authProvider.loggedIn)
                const CircularProgressIndicator()
              else ...[
                if (isLogin) ...[
                  TextField(
                    controller: _meterNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Meter Number',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                ] else ...[
                  TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _accountNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Account Number (optional)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _meterNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Meter Number (optional)',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                ],
                const SizedBox(height: 20),
                isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          setState(() => isLoading = true);
                          bool success = false;

                          if (isLogin) {
                            success = await authProvider.login(
                              _meterNumberController.text.trim(),
                              _passwordController.text.trim(),
                            );
                          } else {
                            success = await authProvider.register({
                              'firstName': _firstNameController.text.trim(),
                              'lastName': _lastNameController.text.trim(),
                              'address': _addressController.text.trim(),
                              'accountNumber':
                                  _accountNumberController.text.isEmpty
                                  ? null
                                  : int.parse(
                                      _accountNumberController.text.trim(),
                                    ),
                              'meterNumber': _meterNumberController.text.isEmpty
                                  ? null
                                  : int.parse(
                                      _meterNumberController.text.trim(),
                                    ),
                              'password': _passwordController.text.trim(),
                            });
                          }

                          setState(() => isLoading = false);

                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isLogin
                                      ? 'Login failed'
                                      : 'Registration failed',
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(isLogin ? 'Login' : 'Register'),
                      ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    setState(() => isLogin = !isLogin);
                  },
                  child: Text(
                    isLogin
                        ? "Don't have an account? Register"
                        : "Already registered? Login",
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
