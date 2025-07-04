import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning_app/providers/auth_provider.dart';
import 'package:learning_app/providers/user_provider.dart';
import 'package:learning_app/screens/login_screen.dart';
import 'package:learning_app/screens/user_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthProvider _authProvider = AuthProvider();
  final UserProvider _userProvider = UserProvider();

  logOut() async {
    await _authProvider.logout();

    await _userProvider.clearUserData(); 

    if (mounted) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "SETTINGS",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height:10),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              tileColor: Colors.purple.shade300,
              title: Text(
                "Your account",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const UserProfileScreen(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              tileColor: Colors.purple.shade300,
              title: Text(
                "Log Out",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
              onTap: () {
                logOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
