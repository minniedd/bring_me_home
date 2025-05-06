// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning_app/components/my_button.dart';
import 'package:learning_app/providers/auth_provider.dart';
import 'package:learning_app/screens/animal_list_screen.dart';
import 'package:learning_app/screens/login_screen.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorMessage;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhoneNumber(String phone) {
    return RegExp(r'^\+?(?:[0-9]|-){10,15}$').hasMatch(phone);
  }

  Future<void> _performSignUp() async {
    setState(() => _errorMessage = null);
    //validation
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // checking if passwords match
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // mapping data
      final userData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'email': _emailController.text.trim(),
        'username': _usernameController.text.trim(),
        'password': _passwordController.text,
        'phoneNumber': _phoneNumberController.text.trim(),
        'isActive': true
      };

      // registering user
      final success = await authProvider.register(userData);

      if (!mounted) return;

      if (success) {
        // navigation
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful! Please login.')));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        setState(() => _errorMessage =
            'Registration failed. Username or email may already be in use.');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _errorMessage = 'An error occurred: ${e.toString()}');
        debugPrint('Registration error: $e');
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
          'SIGN UP',
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
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'First Name',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60, right: 10),
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Last Name'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 60, right: 10, bottom: 15),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'E-mail',
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your e-mail';
                          }
                          if (!_isValidEmail(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 60, right: 10, bottom: 15),
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Username',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          if (value.length < 4) {
                            return 'Username must be at least 4 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 60, right: 10, bottom: 15),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 60, right: 10, bottom: 15),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          border: const UnderlineInputBorder(),
                          labelText: 'Repeat Password',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscureConfirmPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 60, right: 10, bottom: 15),
                      child: TextFormField(
                        controller: _phoneNumberController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Phone Number',
                        ),
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          if (!_isValidPhoneNumber(value)) {
                            return 'Please enter a valid phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 100, left: 100),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.purple,
                            )
                          : MyButton(
                              buttonText: "sign up",
                              onTap: _isLoading ? null : _performSignUp,
                            ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already an user?  "),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: Text(
                            "Login in here",
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
