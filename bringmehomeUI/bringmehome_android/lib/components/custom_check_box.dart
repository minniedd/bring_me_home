import 'package:flutter/material.dart';

class CustomCheckBox extends StatelessWidget {
  final String titleText;
  const CustomCheckBox({super.key, required this.titleText});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      selectedTileColor: Colors.white,
      title: Text(titleText,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 15),),
      value: true, 
      onChanged: (v){});
  }
}