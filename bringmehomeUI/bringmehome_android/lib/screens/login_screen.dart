import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning_app/components/my_button.dart';
import 'package:learning_app/screens/animal_list_screen.dart';
import 'package:learning_app/screens/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = false;
  Color _emailColor = Colors.black;

  bool validateEmail(TextEditingController controller) {
    final emailRegex = RegExp(
        r"[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]+");

    if (controller.text.isEmpty) {
      setState(() {
        _emailColor = Colors.red; // Change color to red on empty field
      });
      return false;
    } else if (emailRegex.hasMatch(controller.text) == false) {
      setState(() {
        _emailColor = Colors.red; // Change color to red on invalid format
      });
      return false;
    }
    setState(() {
      _emailColor = Colors.black; // Reset color to black on valid input
    });
    return true;
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
            constraints: BoxConstraints(maxHeight: 670, minHeight: 670),
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
                  padding:
                      const EdgeInsets.only(left: 60, right: 10, bottom: 15),
                  child: TextFormField(
                    controller: widget._emailController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'e-mail',
                    ),
                    style: TextStyle(color: _emailColor),
                    onChanged: (value) => validateEmail(widget._emailController)
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 10),
                  child: TextFormField(
                    controller: widget._passwordController,
                    obscureText: !_showPassword,
                    decoration:  InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(_showPassword ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                        ),
                        border: UnderlineInputBorder(), labelText: 'password'),
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 100, left: 100),
                  child: MyButton(
                    buttonText: "login",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AnimalListScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Need an account?  "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
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
    );
  }
}
