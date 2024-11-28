import 'package:bringmehome_admin/components/animal_window.dart';
import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:flutter/material.dart';

class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        titleText: 'ZAHTJEVI',
        child: SingleChildScrollView(
          child: Column(
            children: [
              Icon(Icons.filter_alt_rounded),
              Text("Filter by"),
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Wrap(
                      spacing: 20.0,
                      runSpacing: 20.0,
                      children: [
                        AnimalWindowWidget(
                            animalName: "animalName",
                            animalAge: "animalAge",
                            shelterCity: "shelterCity",
                            onTap: () {}),
                        AnimalWindowWidget(
                            animalName: "animalName",
                            animalAge: "animalAge",
                            shelterCity: "shelterCity",
                            onTap: () {}),
                        AnimalWindowWidget(
                            animalName: "animalName",
                            animalAge: "animalAge",
                            shelterCity: "shelterCity",
                            onTap: () {}),
                        AnimalWindowWidget(
                            animalName: "animalName",
                            animalAge: "animalAge",
                            shelterCity: "shelterCity",
                            onTap: () {}),
                        AnimalWindowWidget(
                            animalName: "animalName",
                            animalAge: "animalAge",
                            shelterCity: "shelterCity",
                            onTap: () {}),
                        AnimalWindowWidget(
                            animalName: "animalName",
                            animalAge: "animalAge",
                            shelterCity: "shelterCity",
                            onTap: () {}),
                        AnimalWindowWidget(
                            animalName: "animalName",
                            animalAge: "animalAge",
                            shelterCity: "shelterCity",
                            onTap: () {}),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
