// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final String titleText;
  final bool value; 
  final ValueChanged<bool?>? onChanged; 

  const CustomCheckBox({
    super.key,
    required this.titleText,
    required this.value, 
    this.onChanged, 
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      selectedTileColor: Colors.white,
      checkColor: Theme.of(context).colorScheme.primary, 
      activeColor: Colors.white,
      tileColor: Theme.of(context).colorScheme.primary,
      title: Text(
        titleText,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}