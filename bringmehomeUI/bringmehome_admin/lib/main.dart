import 'package:bringmehome_admin/screens/login_screen.dart';
import 'package:bringmehome_admin/services/auth_provider.dart';
import 'package:bringmehome_admin/theme/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Bring Me Home Admin',
        theme: themeData,
        home: LoginScreen(),
      ),
    );
  }
}