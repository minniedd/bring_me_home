import 'dart:io';

import 'package:bringmehome_admin/screens/applications_screen.dart';
import 'package:bringmehome_admin/screens/available_animals_screen.dart';
import 'package:bringmehome_admin/screens/login_screen.dart';
import 'package:bringmehome_admin/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';

class MasterScreenWidget extends StatefulWidget {
  final Widget? child;
  final String? titleText;

  MasterScreenWidget({required this.child, required this.titleText, Key? key})
      : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget>
    with WindowListener {
  final AuthProvider _authProvider = AuthProvider();

  logOut() async {
    await _authProvider.logout();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _initializeWindowManager();
  }

  Future<void> _initializeWindowManager() async {
    await windowManager.ensureInitialized();

    if (Platform.isWindows) {
      await windowManager.setMinimumSize(const Size(1100, 400));
      await windowManager.setMaximumSize(const Size(2048, 1080));
      await windowManager.setTitle(widget.titleText ?? 'Master Screen');
    }
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Theme.of(context)
                  .colorScheme
                  .onSecondary, 
              onPressed: () {
                Navigator.canPop(context);
              },
              tooltip: 'Back',
            ),
            const SizedBox(width: 10,),
            Text(
              widget.titleText ?? "",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/cat.png',
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.pets),
              title: Text('DOSTUPNE ŽIVOTINJE'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AvailableAnimalsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.paste_sharp),
              title: Text('ZAHTJEVI'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ApplicationsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.add_box_rounded),
              title: Text('DODAJ OGLAS'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_2_sharp),
              title: Text('ZAPOSLENICI'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_3_outlined),
              title: Text('KORISNICI'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.auto_graph_outlined),
              title: Text('IZVJEŠTAJI'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.star_rate_rounded),
              title: Text('RECENZIJE'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              focusColor: Colors.red.shade200,
              leading: const Icon(
                Icons.logout_rounded,
                color: Color.fromRGBO(239, 83, 80, 1),
              ),
              title: const Text(
                'LOGOUT',
                style: TextStyle(color: Color.fromRGBO(239, 83, 80, 1)),
              ),
              onTap: () {
                logOut();
              },
            ),
          ],
        ),
      ),
      body: widget.child!,
    );
  }
}
