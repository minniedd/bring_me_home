import 'package:bringmehome_admin/components/animal_contrainer.dart';
import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:flutter/material.dart';

class AvailableAnimalsScreen extends StatelessWidget {
  const AvailableAnimalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
    titleText: 'DOSTUPNE ŽIVOTINJE',
    child: Center(
      child: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Wrap(
              spacing: 20.0, 
              runSpacing: 20.0, 
              children: [
                AnimalContainer(),
                AnimalContainer(),
                AnimalContainer(),
                AnimalContainer(),
                AnimalContainer(),
                AnimalContainer(),
                AnimalContainer(),
                AnimalContainer(),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}