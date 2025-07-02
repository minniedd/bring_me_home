import 'package:flutter/material.dart';
import 'package:learning_app/components/custom_text.dart';

class MyDialog extends StatelessWidget {
  final String shelterName;
  final String email;
  final String phoneNumber;
  final String address;
  const MyDialog({super.key, required this.shelterName, required this.email, required this.phoneNumber, required this.address});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      content: SizedBox(
        height: 310,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(child: CustomText(textCustom: shelterName)),
            Expanded(child: CustomText(textCustom: email)),
            Expanded(child: CustomText(textCustom: phoneNumber)),
            Expanded(child: CustomText(textCustom: address)),
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
              side: const BorderSide(color: Colors.white,width: 2),
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