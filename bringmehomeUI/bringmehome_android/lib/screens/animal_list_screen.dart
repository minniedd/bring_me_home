import 'package:flutter/material.dart';
import 'package:learning_app/components/animal_window.dart';
import 'package:learning_app/models/animal.dart';
import 'package:learning_app/models/canton.dart';
import 'package:learning_app/models/search_objects/animal_search_object.dart';
import 'package:learning_app/models/search_result.dart';
import 'package:learning_app/models/species.dart';
import 'package:learning_app/providers/animal_provider.dart';
import 'package:learning_app/providers/canton_provider.dart';
import 'package:learning_app/providers/species_provider.dart';
import 'package:learning_app/screens/animal_screen.dart';
import 'package:learning_app/widgets/master_screen.dart';

class AnimalListScreen extends StatefulWidget {
  const AnimalListScreen({super.key});

  @override
  State<AnimalListScreen> createState() => _AnimalListScreenState();
}

class _AnimalListScreenState extends State<AnimalListScreen> {
  final AnimalProvider _animalProvider = AnimalProvider();
  final SpeciesProvider _speciesProvider = SpeciesProvider();
  final CantonProvider _cantonProvider = CantonProvider();
  final ScrollController _scrollController = ScrollController();
  SearchResult<Animal> _animalResult = SearchResult<Animal>();
  bool _isLoading = false;
  bool _hasMore = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  final AnimalSearchObject _searchObject = AnimalSearchObject();
  List<Species> _availableSpecies = [];
  bool _isLoadingSpecies = false;
  int? _selectedSpeciesId;
  List<Canton> _availableCantons = [];
  bool _isLoadingCantons = false;
  int? _selectedCantonId;
  bool _showSpeciesFilters = false;
  bool _showCantonFilters = false;

  @override
  void initState() {
    super.initState();
    _loadAnimals();
    _loadSpecies();
    _loadCantons();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
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

  Future<void> _loadSpecies() async {
    setState(() {
      _isLoadingSpecies = true;
    });

    try {
      final species = await _speciesProvider.getSpecies();
      setState(() {
        _availableSpecies = species;
        _isLoadingSpecies = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingSpecies = false;
      });
    }
  }

  void _selectSpecies(int? speciesId) {
    setState(() {
      if (_selectedSpeciesId == speciesId) {
        _selectedSpeciesId = null;
      } else {
        _selectedSpeciesId = speciesId;
      }
      _searchObject.speciesID = _selectedSpeciesId;
    });
    _loadAnimals(reset: true);
  }

  Future<void> _loadCantons() async {
    setState(() {
      _isLoadingCantons = true;
    });

    try {
      final cantons = await _cantonProvider.getCantons();
      setState(() {
        _availableCantons = cantons;
        _isLoadingCantons = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCantons = false;
      });
    }
  }

  void _selectCantons(int? cantonId) {
    setState(() {
      if (_selectedCantonId == cantonId) {
        _selectedCantonId = null;
      } else {
        _selectedCantonId = cantonId;
      }
      _searchObject.cantonID = _selectedCantonId;
    });
    _loadAnimals(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleText: "HOME",
      child: Container(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          controller: _scrollController,
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
              const SizedBox(
                height: 20,
              ),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Filter by Species',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade700,
                        ),
                      ),
                      trailing: Icon(
                        _showSpeciesFilters
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: Colors.deepPurple.shade300,
                      ),
                      onTap: () {
                        setState(() {
                          _showSpeciesFilters = !_showSpeciesFilters;
                        });
                      },
                    ),
                    if (_showSpeciesFilters) ...[
                      if (_isLoadingSpecies)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              color: Colors.deepPurple.shade300,
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: SizedBox(
                            height: 50,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: FilterChip(
                                      avatar: Icon(
                                        Icons.all_inclusive,
                                        color: _selectedSpeciesId == null
                                            ? Colors.white
                                            : Colors.deepPurple.shade300,
                                        size: 18,
                                      ),
                                      label: const Text("All"),
                                      selected: _selectedSpeciesId == null,
                                      selectedColor: Colors.deepPurple.shade400,
                                      labelStyle: TextStyle(
                                        color: _selectedSpeciesId == null
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: _selectedSpeciesId == null
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                      backgroundColor: Colors.grey.shade200,
                                      onSelected: (bool selected) {
                                        if (selected) {
                                          _selectSpecies(null);
                                        }
                                      },
                                    ),
                                  ),
                                  ..._availableSpecies.map((species) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: FilterChip(
                                        label: Text(species.speciesName),
                                        selected: _selectedSpeciesId ==
                                            species.speciesID,
                                        selectedColor:
                                            Colors.deepPurple.shade400,
                                        labelStyle: TextStyle(
                                          color: _selectedSpeciesId ==
                                                  species.speciesID
                                              ? Colors.white
                                              : Colors.black87,
                                          fontWeight: _selectedSpeciesId ==
                                                  species.speciesID
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                        backgroundColor: Colors.grey.shade200,
                                        onSelected: (bool selected) {
                                          if (selected) {
                                            _selectSpecies(species.speciesID);
                                          }
                                        },
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Filter by Canton',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade700,
                        ),
                      ),
                      trailing: Icon(
                        _showCantonFilters
                            ? Icons.expand_less
                            : Icons.expand_more,
                        color: Colors.deepPurple.shade300,
                      ),
                      onTap: () {
                        setState(() {
                          _showCantonFilters = !_showCantonFilters;
                        });
                      },
                    ),
                    if (_showCantonFilters) ...[
                      if (_isLoadingCantons)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              color: Colors.deepPurple.shade300,
                            ),
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: SizedBox(
                            height: 50,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: FilterChip(
                                      avatar: Icon(
                                        Icons.all_inclusive,
                                        color: _selectedCantonId == null
                                            ? Colors.white
                                            : Colors.deepPurple.shade300,
                                        size: 18,
                                      ),
                                      label: const Text("All"),
                                      selected: _selectedCantonId == null,
                                      selectedColor: Colors.deepPurple.shade400,
                                      labelStyle: TextStyle(
                                        color: _selectedCantonId == null
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: _selectedCantonId == null
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                      backgroundColor: Colors.grey.shade200,
                                      onSelected: (bool selected) {
                                        if (selected) {
                                          _selectCantons(null);
                                        }
                                      },
                                    ),
                                  ),
                                  ..._availableCantons.map((cantons) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: FilterChip(
                                        label: Text(cantons.cantonName),
                                        selected: _selectedCantonId ==
                                            cantons.cantonID,
                                        selectedColor:
                                            Colors.deepPurple.shade400,
                                        labelStyle: TextStyle(
                                          color: _selectedCantonId ==
                                                  cantons.cantonID
                                              ? Colors.white
                                              : Colors.black87,
                                          fontWeight: _selectedCantonId ==
                                                  cantons.cantonID
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                        backgroundColor: Colors.grey.shade200,
                                        onSelected: (bool selected) {
                                          if (selected) {
                                            _selectCantons(cantons.cantonID);
                                          }
                                        },
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
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
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AnimalWindow(
                        animalName: animal.name ?? 'Unknown',
                        animalAge: '${animal.age}',
                        shelterCity: '${animal.shelterName}',
                        showLikeButton: false,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AnimalScreen(animal: animal),
                            ),
                          );
                        },
                      ),
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
