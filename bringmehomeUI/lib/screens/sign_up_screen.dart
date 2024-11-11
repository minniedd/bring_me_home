import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning_app/components/my_button.dart';
import 'package:learning_app/screens/animal_list_screen.dart';
import 'package:learning_app/screens/login_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'email',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(), labelText: 'password'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 60, right: 10, bottom: 15),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'username',
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 60, right: 10, bottom: 15),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'phone number',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MyButton(
                  buttonText: "sign up",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnimalListScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already an user?  "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
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
    );
  }
}