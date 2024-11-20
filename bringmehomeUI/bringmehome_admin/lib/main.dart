import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/screens/available_animals_screen.dart';
import 'package:bringmehome_admin/theme/theme_data.dart';
import 'package:flutter/material.dart';

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
      home: AvailableAnimalsScreen(),
    );
  }
}
