import 'package:flutter/material.dart';

class SmallContainer extends StatelessWidget {
  final String containerText;
  const SmallContainer({super.key, required this.containerText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 130,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(10)),
      child: Center(
          child: Text(
        containerText,
        style: const TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.w900, 
            fontSize: 20,),
      )),
    );
  }
}
