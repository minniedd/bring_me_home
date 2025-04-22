import 'package:flutter/material.dart';
import 'package:learning_app/components/animal_window.dart';
import 'package:learning_app/widgets/master_screen.dart';

class HistoryApplicationScreen extends StatelessWidget {
  const HistoryApplicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleText: 'HISTORY',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              AnimalWindow(
                  animalName: 'animalName',
                  animalAge: 'animalAge',
                  shelterCity: 'shelterCity',
                  onTap: () {}),
              Container(
                decoration: const BoxDecoration(
                    color: Color.fromRGBO(176, 139, 215, 1),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12))),
                padding: const EdgeInsets.only(left: 100,right: 100,top: 10,bottom: 10),
                child: const Text("Student",style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600
                ),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
