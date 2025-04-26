import 'package:flutter/material.dart';
import 'package:learning_app/components/animal_window.dart';
import 'package:learning_app/models/animal.dart';
import 'package:learning_app/models/search_objects/animal_search_object.dart';
import 'package:learning_app/models/search_result.dart';
import 'package:learning_app/providers/animal_provider.dart';
import 'package:learning_app/screens/animal_screen.dart';
import 'package:learning_app/widgets/master_screen.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  final AnimalProvider _animalProvider = AnimalProvider();
  final ScrollController _scrollController = ScrollController();
  SearchResult<Animal> _animalResult = SearchResult<Animal>();
  bool _isLoading = false;
  bool _hasMore = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  final AnimalSearchObject _searchObject = AnimalSearchObject();

  @override
  void initState() {
    super.initState();
    _loadAnimals();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMoreAnimals();
    }
  }

  Future<void> _loadAnimals({bool reset = false}) async {
    if (reset) {
      _searchObject.pageNumber = 1;
      _hasMore = true;
    }

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final data = await _animalProvider.search(_searchObject);

      setState(() {
        if (reset) {
          _animalResult = data;
        } else {
          _animalResult.result.addAll(data.result);
          _animalResult.count = data.count;
        }
        _hasMore = data.result.length == _searchObject.pageSize;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load animals: ${e.toString()}';
      });
      print('Error loading animals: $e');
    }
  }

  Future<void> _loadMoreAnimals() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _searchObject.pageNumber += 1;
    });

    await _loadAnimals();
  }

  void _handleSearch(String value) {
    _searchObject.fts = value.isNotEmpty ? value : null;
    _loadAnimals(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleText: "HOME",
      child: Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.deepPurple.shade300,
                    size: 35,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _handleSearch('');
                          },
                        )
                      : null,
                ),
                onChanged: _handleSearch,
              ),
              const SizedBox(height: 50),
              Container(
                height: 210,
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Recite nam šta mislite",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Button functionality here
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 45, vertical: 25),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.deepPurple.shade300,
                            ),
                            child: const Text('RECENZIJE'),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Image.asset(
                        'assets/dog.png',
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Text(
                        "Filter",
                        style: TextStyle(
                            color: Colors.deepPurple.shade200,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                      IconButton(
                        onPressed: () {
                          // button func
                        },
                        icon: const Icon(
                          Icons.filter_list_alt,
                          size: 40,
                          color: Color.fromRGBO(176, 139, 215, 1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
             if (_isLoading && _animalResult.result.isEmpty)
            const Center(child: CircularProgressIndicator())
          else if (_errorMessage != null)
            Center(
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            )
          else if (_animalResult.result.isEmpty)
            const Center(child: Text('No animals found'))
          else
            ...List.generate(
              _animalResult.result.length + (_hasMore ? 1 : 0),
              (index) {
                if (index >= _animalResult.result.length) {
                  return _buildLoader();
                }
                final animal = _animalResult.result[index];
                return AnimalWindow(
                  animalName: animal.name ?? 'Unknown',
                  animalAge: '${animal.age}',
                  shelterCity: 'Shelter ID: ${animal.shelterID}',
                  showLikeButton: false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AnimalScreen(animal: animal),
                      ),
                    );
                  },
                );
              },
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return _hasMore
        ? const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: CircularProgressIndicator()),
          )
        : Container();
  }
}
