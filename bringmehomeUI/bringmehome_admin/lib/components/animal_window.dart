import 'package:bringmehome_admin/components/custom_button.dart';
import 'package:flutter/material.dart';

class AnimalWindowWidget extends StatelessWidget {
  final String animalName;
  final String animalAge;
  final String shelterCity;
  final Function()? onTap;
  const AnimalWindowWidget({super.key,
      required this.animalName,
      required this.animalAge,
      required this.shelterCity,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500, 
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.network('https://picsum.photos/250?image=9'),
                  const SizedBox(width: 10,),
                  Text("data")
                ],
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 100,right: 100),
                child: CustomButton(buttonText: "buttonText", onTap: (){}),
              )
            ],
          ),
        ),
      ),
    );
  }
}