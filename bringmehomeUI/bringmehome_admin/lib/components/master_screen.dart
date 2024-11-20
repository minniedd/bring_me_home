import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? titleText;


  MasterScreenWidget({this.child, this.titleText, Key? key}) : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
  appBar: AppBar(
    backgroundColor: Theme.of(context).colorScheme.secondary,
    title: Row(
      children: <Widget>[
        Text(
          widget.titleText ?? "",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
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
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () {
            
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () {
            
            Navigator.pop(context);
          },
        ),
      ],
    ),
  ),
  body: widget.child!,
);
  }
}