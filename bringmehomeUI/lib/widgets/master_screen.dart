import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? titleText;

  MasterScreenWidget({this.child, this.titleText ,Key? key}) : super(key: key);

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.titleText ?? "",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepPurple.shade300,
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        iconSize: 35,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Omiljeni',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Donacije',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Recenzije'),
        ],
      ),
      body: widget.child!,
    );
  }
}
