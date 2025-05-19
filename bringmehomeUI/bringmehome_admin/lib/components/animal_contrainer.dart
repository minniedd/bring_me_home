import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data'; 

class AnimalContainer extends StatelessWidget {
  final String animalName;
  final String? animalImageUrl; 
  final String buttonText;
  final VoidCallback onTap;

  const AnimalContainer({
    super.key,
    required this.animalName,
    this.animalImageUrl,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (animalImageUrl != null && animalImageUrl!.isNotEmpty) {
      try {
        final Uint8List bytes = base64Decode(animalImageUrl!);
        imageWidget = Image.memory(
          bytes,
          height: 200,
          width: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              'assets/image-placeholder.png',
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            );
          },
        );
      } catch (e) {
        imageWidget = Image.asset(
          'assets/image-placeholder.png', 
          height: 200,
          width: 200,
          fit: BoxFit.cover,
        );
      }
    } else {
      imageWidget = Image.asset(
        'assets/image-placeholder.png', 
        width: 200,
        fit: BoxFit.cover,
      );
    }

    return SizedBox(
      height: 400,
      width: 300,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: imageWidget,
              ),
              Text(
                animalName,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(buttonText),
              )
            ],
          ),
        ),
      ),
    );
  }
}