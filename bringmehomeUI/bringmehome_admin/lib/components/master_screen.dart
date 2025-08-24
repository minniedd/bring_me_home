import 'dart:io';

import 'package:bringmehome_admin/screens/add_animal.dart';
import 'package:bringmehome_admin/screens/app_report_screen.dart';
import 'package:bringmehome_admin/screens/applications_screen.dart';
import 'package:bringmehome_admin/screens/available_animals_screen.dart';
import 'package:bringmehome_admin/screens/event_list_screen.dart';
import 'package:bringmehome_admin/screens/login_screen.dart';
import 'package:bringmehome_admin/screens/review_list_screen.dart';
import 'package:bringmehome_admin/screens/staff_list_screen.dart';
import 'package:bringmehome_admin/screens/user_list_screen.dart';
import 'package:bringmehome_admin/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';

class MasterScreenWidget extends StatefulWidget {
  final Widget? child;
  final String? titleText;
  final bool? backButton;

  MasterScreenWidget({required this.child, required this.titleText, Key? key, this.backButton})
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
            if (widget.backButton == true)
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).maybePop();
                },
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
                'Bring Me Home'.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.pets),
              title: Text('available animals'.toUpperCase()),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AvailableAnimalsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.paste_sharp),
              title: Text('animal applications'.toUpperCase()),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ApplicationsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.add_box_rounded),
              title: Text('add animal'.toUpperCase()),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddAnimalScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.person_2_sharp),
              title: Text('staff'.toUpperCase()),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const StaffListScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.person_3_outlined),
              title: Text('users'.toUpperCase()),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const UserListScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.auto_graph_outlined),
              title: Text('reports'.toUpperCase()),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AnimalReportScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.star_rate_rounded),
              title: Text('reviews'.toUpperCase()),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ReviewListScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.event_note_outlined),
              title: Text('events'.toUpperCase()),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EventListScreen()));
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
