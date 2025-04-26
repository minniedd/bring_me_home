import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning_app/screens/animal_list_screen.dart';
import 'package:learning_app/screens/donation_screen.dart';
import 'package:learning_app/screens/favourites_screen.dart';
import 'package:learning_app/screens/history_application.dart';
import 'package:learning_app/screens/reviews_list_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  final Widget? child;
  final String? titleText;

  const MasterScreenWidget({this.child, this.titleText, super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  void _navigateToScreen(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AnimalListScreen()),
        );
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const FavouritesScreen()),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const DonationScreen()),
        );
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ReviewsListScreen()),
        );
        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const HistoryApplicationScreen())
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          GestureDetector(onTap: (){},child: const Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.settings_rounded),
          ))
        ],
        centerTitle: true,
        title: Text(
          widget.titleText ?? "",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _navigateToScreen,
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
          BottomNavigationBarItem(
            icon: Icon(Icons.star), 
            label: 'Recenzije'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history), 
            label: 'Historija'
          ),
        ],
      ),
      body: widget.child!,
    );
  }
}
