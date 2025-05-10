import 'package:flutter/material.dart';
import 'package:learning_app/components/animal_window.dart';
import 'package:learning_app/models/animal.dart';
import 'package:learning_app/providers/favourite_provider.dart';
import 'package:learning_app/screens/animal_screen.dart';
import 'package:learning_app/widgets/master_screen.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final FavouritesProvider _favouriteProvider = FavouritesProvider();
  List<Animal> _favoriteAnimals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() => _isLoading = true);
    try {
      final favorites = await _favouriteProvider.getFavorites();
      setState(() {
        _favoriteAnimals = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load favorites'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool?> _toggleFavorite(int animalId, bool isFavorite) async {
    try {
      final success =
          await _favouriteProvider.toggleFavorite(animalId, !isFavorite);
      if (success) {
        await _loadFavorites();
        return !isFavorite;
      }
      return isFavorite;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update favorite'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return isFavorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleText: "FAVOURITES",
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _favoriteAnimals.isEmpty
                ? const Center(child: Text('No favorites yet'))
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: _favoriteAnimals.length,
                    itemBuilder: (context, index) {
                      final animal = _favoriteAnimals[index];
                      return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                        child: AnimalWindow(
                          animalName: animal.name ?? 'Unknown',
                          animalAge: animal.age?.toString() ?? 'Unknown',
                          shelterCity: '${animal.shelterName}',
                          isFavorite: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AnimalScreen(animal: animal),
                              ),
                            );
                          },
                          onLikeTap: (isLiked) =>
                              _toggleFavorite(animal.animalID!, isLiked),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
