// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class AnimalWindow extends StatelessWidget {
  final String animalName;
  final String animalAge;
  final String shelterCity;
  final Function()? onTap;
  const AnimalWindow(
      {super.key,
      required this.animalName,
      required this.animalAge,
      required this.shelterCity,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 5),
          borderRadius: BorderRadius.circular(30)
        ),
        child: Card(
          child: Row(
            children: [
              Expanded(
                flex: 40,
                child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset('assets/meowmeow.jpg'))),
              ),
              Expanded(
                flex: 60,
                child: Column(
                  children: [
                    Expanded(
                      flex: 50,
                      child: Center(
                          child: Text(
                        animalName,
                        style:
                            TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                      )),
                    ),
                    Expanded(flex: 25, child: Text("$animalAge years old")),
                    Expanded(flex: 25, child: Text(shelterCity)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
