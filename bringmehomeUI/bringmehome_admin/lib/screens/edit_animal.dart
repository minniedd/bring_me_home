import 'package:bringmehome_admin/components/custom_button.dart';
import 'package:bringmehome_admin/components/custom_text_field.dart';
import 'package:bringmehome_admin/components/delete_button.dart';
import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:flutter/material.dart';

class EditAnimalDataScreen extends StatefulWidget {
  const EditAnimalDataScreen({super.key});

  @override
  State<EditAnimalDataScreen> createState() => _EditAnimalDataScreenState();
}

class _EditAnimalDataScreenState extends State<EditAnimalDataScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleText: 'UREDI OGLAS',
      child: Center(
        child: Container(
            height: 500,
            width: 1000,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          'https://picsum.photos/250?image=9',
                          height: 300,
                          width: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                      //checkbox

                      // Button
                      CustomButton(buttonText: 'OBRIŠI', onTap: (){},color: Theme.of(context).colorScheme.error,)
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(hintText: 'Animal Name'),
                        const SizedBox(height: 20),
                        CustomTextField(hintText: 'Animal Type'),
                        const SizedBox(height: 20),
                        CustomTextField(hintText: 'Animal Breed'),
                        const SizedBox(height: 20),
                        CustomTextField(hintText: 'Animal Age'),
                        const SizedBox(height: 20),
                        CustomTextField(hintText: 'Animal Gender'),
                        const SizedBox(height: 20),
                        CustomTextField(hintText: 'Animal Weight'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              hintText: 'About',
                              hintStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          keyboardType: TextInputType.multiline,
                          maxLines: 14,
                        ),
                        const SizedBox(height: 30,),
                        Padding(
                          padding: const EdgeInsets.only(left:50,right: 50),
                          child: CustomButton(buttonText: "POTVRDI", onTap: (){},color: Colors.green.shade400,),
                        )
                      ],
                    ),
                  ),
                )
                //fff
              ],
            )),
      ),
    );
  }
}
