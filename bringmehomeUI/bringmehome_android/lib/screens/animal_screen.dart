import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:learning_app/components/my_button.dart';
import 'package:learning_app/components/my_dialog.dart';
import 'package:learning_app/models/animal.dart';
import 'package:learning_app/providers/favourite_provider.dart';
import 'package:learning_app/screens/application.dart';
import 'package:like_button/like_button.dart';

import '../components/small_contrainer.dart';

class AnimalScreen extends StatefulWidget {
  final Animal animal;

  const AnimalScreen({super.key, required this.animal});

  @override
  State<AnimalScreen> createState() => _AnimalScreenState();
}

class _AnimalScreenState extends State<AnimalScreen> {
  final FavouritesProvider _favouriteProvider = FavouritesProvider();
  late bool _isFavorite;
  String? _animalImage;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.animal.isFavorite;
    _animalImage = widget.animal.animalImage;
    _refreshFavoriteStatus();
  }

  Future<void> _refreshFavoriteStatus() async {
    final favorites = await _favouriteProvider.getFavorites();
    if (mounted) {
      setState(() {
        _isFavorite = favorites
            .any((animal) => animal.animalID == widget.animal.animalID);
        widget.animal.isFavorite = _isFavorite;
      });
    }
  }

  Widget _buildImageWidget() {
    if (_animalImage != null && _animalImage!.isNotEmpty) {
      try {
        String base64String = _animalImage!;
        if (base64String.contains(',')) {
          base64String = base64String.split(',').last;
        }

        final Uint8List bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Error loading image from memory: $error');
            return Image.asset(
              'assets/meowmeow.jpg',
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            );
          },
        );
      } catch (e) {
        print('Error decoding base64: $e');
        return Image.asset(
          'assets/meowmeow.jpg',
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
        );
      }
    } else {
      return Image.asset(
        'assets/meowmeow.jpg',
        height: 300,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        toolbarHeight: 50,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: _buildImageWidget(),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.animal.name ?? "Unknown",
                      style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return MyDialog(
                                  shelterName: widget.animal.shelter?.name ?? 'Nepoznato',
                                  email: widget.animal.shelter?.email ?? 'Nepoznato',
                                  phoneNumber: widget.animal.shelter?.phone ?? 'Nepoznato',
                                  address: widget.animal.shelter?.address ?? 'Nepoznato',
                                );
                              });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 3,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text("SKLONIŠTE"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 60),
                      child: Text(
                        "Rasa: ${widget.animal.breedName ?? 'Nepoznato'}",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w800),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        widget.animal.shelterName ?? 'Nepoznato',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w800),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SmallContainer(
                      containerText: 'Godina: ${widget.animal.age ?? 'N/A'}'),
                  SmallContainer(
                      containerText: widget.animal.gender ?? 'Nepoznato'),
                  SmallContainer(
                      containerText: '${widget.animal.weight ?? 'N/A'} kg')
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "About:",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.animal.description ??
                        "No description available."),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LikeButton(
                    size: 50,
                    isLiked: _isFavorite,
                    onTap: (isLiked) async {
                      if (widget.animal.animalID == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cannot favorite this animal'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return isLiked;
                      }

                      final success = await _favouriteProvider.toggleFavorite(
                          widget.animal.animalID!, !isLiked);

                      if (success) {
                        setState(() {
                          _isFavorite = !isLiked;
                          widget.animal.isFavorite = !isLiked;
                        });
                        return !isLiked;
                      }

                      if (!mounted) return isLiked;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to update favorite status'),
                          backgroundColor: Colors.red,
                        ),
                      );

                      return isLiked;
                    },
                    likeBuilder: (bool isLiked) {
                      return Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                        size: 50,
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: MyButton(
                        onTap: () {
                          if (widget.animal.animalID != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ApplicationScreen(
                                    animalId: widget.animal.animalID!),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Animal ID is missing. Cannot apply.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        buttonText: 'Usvoji'),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
