import 'package:flutter/material.dart';
import 'package:learning_app/components/custom_text.dart';

class MyDialog extends StatelessWidget {
  const MyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      content: Container(
        height: 310,
        child: Column(
          children: [
            CustomText(textCustom: 'Sklonište: Sarajevo'),
            CustomText(textCustom: 'E-mail: example@example.com'),
            CustomText(textCustom: 'Broj telefona: 062 089 721'),
            CustomText(textCustom: 'Adresa: Example 18'),
          ],
        ),
      ),
      actions: <Widget>[
        Center(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              side: BorderSide(color: Colors.white,width: 2),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Close',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
