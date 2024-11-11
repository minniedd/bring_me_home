import 'package:flutter/material.dart';
import 'package:learning_app/components/animal_window.dart';
import 'package:learning_app/screens/donation_screen.dart';
import 'package:learning_app/widgets/master_screen.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        titleText: "FAVOURITES",
        child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                AnimalWindow(
                  animalName: 'ime',
                  animalAge: '5',
                  shelterCity: 'Sarajevo',
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DonationScreen()));
                  },
                )
              ],
            )));
  }
}
