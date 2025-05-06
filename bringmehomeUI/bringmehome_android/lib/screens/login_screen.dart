import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning_app/components/my_button.dart';
import 'package:learning_app/providers/auth_provider.dart';
import 'package:learning_app/screens/animal_list_screen.dart';
import 'package:learning_app/screens/sign_up_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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
    setState(() => _errorMessage = null);

    // Validate form
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      final success = await authProvider.login(username, password);

      if (!mounted) return;

      if (success) {
        // if login success, navigate to list of animals (main page)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AnimalListScreen()),
        );
      } else {
        // login failed - invalid credentials
        setState(() => _errorMessage = 'Invalid username or password');
      }
    } on SocketException catch (_) {
      if (mounted) {
        setState(() =>
            _errorMessage = 'Network error. Please check your connection.');
      }
    } on FormatException catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Unexpected response from server');
      }
    } on http.ClientException catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'Connection error: ${e.message}');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'An error occurred: ${e.toString()}');
      }
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
                          left: 60, right: 10, bottom: 15),
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
                      padding: const EdgeInsets.only(left: 60, right: 10),
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
                          : MyButton(
                              buttonText: "login",
                              onTap: () => _performLogin(context),
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
