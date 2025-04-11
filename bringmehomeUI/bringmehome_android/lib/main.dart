import 'package:flutter/material.dart';
import 'package:learning_app/providers/auth_provider.dart';
import 'package:learning_app/screens/login_screen.dart';
import 'package:learning_app/theme/themeData.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData,
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}