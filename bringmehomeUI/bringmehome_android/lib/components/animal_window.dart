import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

class AnimalWindow extends StatelessWidget {
  final String animalName;
  final String animalAge;
  final String shelterCity;
  final bool isFavorite;
  final bool showLikeButton;
  final VoidCallback onTap;
  final Future<bool?> Function(bool)? onLikeTap;

  const AnimalWindow({
    super.key,
    required this.animalName,
    required this.animalAge,
    required this.shelterCity,
    required this.onTap,
    this.isFavorite = false,
    this.showLikeButton = true, 
    this.onLikeTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 5),
              borderRadius: BorderRadius.circular(30)),
          child: Stack(
            children: [
              Card(
                child: Row(
                  children: [
                    Expanded(
                      flex: 40,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset('assets/meowmeow.jpg'))),
                    ),
                    Expanded(
                      flex: 60,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 50,
                            child: Center(
                                child: Text(
                              animalName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 30),
                            )),
                          ),
                          Expanded(flex: 25, child: Text("$animalAge years old")),
                          Expanded(flex: 25, child: Text(shelterCity)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if (showLikeButton)
                Positioned(
                  top: 8,
                  right: 8,
                  child: LikeButton(
                    size: 30,
                    isLiked: isFavorite,
                    onTap: onLikeTap,
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 30,
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
