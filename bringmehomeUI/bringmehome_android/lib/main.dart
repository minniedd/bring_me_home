import 'package:flutter/material.dart';
import 'package:learning_app/providers/adoption_application_provider.dart';
import 'package:learning_app/providers/auth_provider.dart';
import 'package:learning_app/providers/favourite_provider.dart';
import 'package:learning_app/providers/review_provider.dart';
import 'package:learning_app/providers/user_provider.dart';
import 'package:learning_app/screens/login_screen.dart';
import 'package:learning_app/theme/theme_data.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AdoptionApplicationProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FavouritesProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),

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
      home: const LoginScreen(),
    );
  }
}