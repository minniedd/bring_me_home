import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String textCustom;
  const CustomText({super.key, required this.textCustom});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.white,width: 3,),borderRadius: BorderRadius.circular(15)),
      child: Center(
        child: Text(
          textCustom,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15,color: Colors.white),
        ),
      ),
    );
  }
}
