import 'dart:async';
import 'dart:io';
import 'package:bringmehome_admin/screens/available_animals_screen.dart';
import 'package:bringmehome_admin/screens/sing_up.dart';
import 'package:bringmehome_admin/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _performLogin(BuildContext context) async {

  if (mounted) {
    setState(() => _errorMessage = null);
  }
  if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
    return;
  }
  if (mounted) {
    setState(() => _isLoading = true);
  }

  try {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    final success = await authProvider.login(username, password);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const AvailableAnimalsScreen(),
        ),
      );
    } else {
      setState(() => _errorMessage = 'Invalid username or password');
    }
  } on SocketException catch (_) {
    if (mounted) {
      setState(() => _errorMessage = 'Network error. Please check your connection.');
    }
  } on FormatException catch (_) {
    if (mounted) {
      setState(() => _errorMessage = 'Invalid response from server. Please try again.');
    }
  } on ProviderNotFoundException catch (e) {
    if (mounted) {
      setState(() => _errorMessage = 'Application setup error. Please restart the app.');
    }
    debugPrint('Provider error: $e');
  } on HttpException catch (e) {
    if (mounted) {
      setState(() => _errorMessage = 'Connection error: ${e.message}');
    }
  } on TimeoutException catch (_) {
    if (mounted) {
      setState(() => _errorMessage = 'Request timeout. Please try again.');
    }
  } catch (e) {
    if (mounted) {
      setState(() => _errorMessage = 'Login failed. Please try again.');
    }
    debugPrint('Login error: $e');
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'LOGIN',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Center(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 670, minHeight: 670),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset('assets/cat.png'),
                    Padding(
                      padding: const EdgeInsets.only(top: 25, bottom: 25),
                      child: Text(
                        'BRING ME HOME!',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 400, right: 400, bottom: 15),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'username',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 400, right: 400),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(_showPassword
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded),
                              onPressed: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                            ),
                            border: const UnderlineInputBorder(),
                            labelText: 'password'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    const SizedBox(height: 35),
                    Padding(
                      padding: const EdgeInsets.only(right: 100, left: 100),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.purple,
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                _performLogin(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'Login',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Need an account?  "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUpScreen()));
                          },
                          child: Text(
                            "Sign up here",
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
