import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learning_app/components/custom_check_box.dart';
import 'package:learning_app/components/custom_text_field.dart';
import 'package:learning_app/screens/application_congrats_screen.dart';

class ApplicationScreen extends StatefulWidget {
  const ApplicationScreen({super.key});

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(
          "APPLICATION",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: currentStep == 0
          ? StepOne(onNext: () => setState(() => currentStep = 1))
          : StepTwo(onBack: () => setState(() => currentStep = 0)),
    );
  }
}

class StepOne extends StatelessWidget {
  final VoidCallback onNext;

  const StepOne({required this.onNext, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CustomTextField(hintText: 'ime i prezime', obscureText: false),
          const CustomTextField(hintText: 'adresa', obscureText: false),
          const CustomTextField(hintText: 'grad', obscureText: false),
          const CustomTextField(hintText: 'email', obscureText: false),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onNext,
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}

class StepTwo extends StatelessWidget {
  final VoidCallback onBack;

  const StepTwo({required this.onBack, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomTextField(hintText: 'U kakvoj vrsti stanovanja živite?', obscureText: false),
          const CustomTextField(hintText: 'Jesu li dozvoljeni kućni ljubimci?', obscureText: false),
          const SizedBox(height: 10),
          const Text('Zašto želite usvojiti ovog ljubimca?',style: TextStyle(color: Colors.white),),
          const SizedBox(height: 20),
          const CustomCheckBox(titleText: 'Saputnik za dijete'),
          const CustomCheckBox(titleText: 'Saputnik za drugog ljubimca'),
          const CustomCheckBox(titleText: 'Saputnik za sebe'),
          const CustomCheckBox(titleText: 'Uslužna životinja'),
          const CustomCheckBox(titleText: 'Sigurnost'),
          const CustomCheckBox(titleText: 'Kućni ljubimac'),
          const CustomTextField(hintText: 'Ostalo', obscureText: false),
          const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: onBack, child: const Icon(Icons.arrow_back),),
                ElevatedButton(onPressed: (){
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ApplicationCongratsScreen(),
                        ),
                      );
                }, child: const Text("Potvrdi"),),
              ],
            ),
        ],
      ),
    );
  }
}
