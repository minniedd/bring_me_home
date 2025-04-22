import 'package:flutter/material.dart';
import 'package:learning_app/components/my_button.dart';
import 'package:learning_app/screens/animal_list_screen.dart';

class ApplicationCongratsScreen extends StatelessWidget {
  const ApplicationCongratsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'BRING ME HOME',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Image.asset(
              'assets/ballons.png',
              height: 300,
              width: 300,
            ),
            const Text(
              'ČESTITAMO!',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 40),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Uspješno ste poslali zahtjev za usvajanje!',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            const SizedBox(
              height: 130,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'Strpljivo pričekajte naš odgovor našeg osoblja o odluci/sljedećim koracima usvojenja.',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100),
              child: MyButton(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnimalListScreen(),
                      ),
                    );
                  },
                  buttonText: 'POTVRDI'),
            )
          ],
        ),
      ),
    );
  }
}
