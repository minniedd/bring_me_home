import 'package:flutter/material.dart';
import 'package:learning_app/screens/login_screen.dart';
import 'package:learning_app/theme/themeData.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      home: const LoginScreen(),
    );
  }
}
