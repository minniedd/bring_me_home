import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String buttonText;
  final Color? color;
  const CustomButton({super.key,required this.buttonText,required this.onTap,this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.only(right: 50,left: 50,top: 10,bottom: 10),
        //margin: const EdgeInsets.symmetric(horizontal: 100),
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ),
    );
  }
}