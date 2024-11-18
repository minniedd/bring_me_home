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

  const StepOne({required this.onNext, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CustomTextField(hintText: 'ime i prezime', obscureText: false),
          CustomTextField(hintText: 'adresa', obscureText: false),
          CustomTextField(hintText: 'grad', obscureText: false),
          CustomTextField(hintText: 'email', obscureText: false),
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

  const StepTwo({required this.onBack, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(hintText: 'U kakvoj vrsti stanovanja živite?', obscureText: false),
          CustomTextField(hintText: 'Jesu li dozvoljeni kućni ljubimci?', obscureText: false),
          const SizedBox(height: 10),
          const Text('Zašto želite usvojiti ovog ljubimca?',style: TextStyle(color: Colors.white),),
          const SizedBox(height: 20),
          CustomCheckBox(titleText: 'Saputnik za dijete'),
          CustomCheckBox(titleText: 'Saputnik za drugog ljubimca'),
          CustomCheckBox(titleText: 'Saputnik za sebe'),
          CustomCheckBox(titleText: 'Uslužna životinja'),
          CustomCheckBox(titleText: 'Sigurnost'),
          CustomCheckBox(titleText: 'Kućni ljubimac'),
          CustomTextField(hintText: 'Ostalo', obscureText: false),
          const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: onBack, child: const Icon(Icons.arrow_back),),
                ElevatedButton(onPressed: (){
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplicationCongratsScreen(),
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
