import 'package:bringmehome_admin/components/animal_window.dart';
import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/models/animal.dart';
import 'package:bringmehome_admin/models/search_objects/animal_search_object.dart';
import 'package:bringmehome_admin/models/search_result.dart';
import 'package:bringmehome_admin/screens/animal_applications_screen.dart';
import 'package:bringmehome_admin/services/animal_provider.dart';
import 'package:bringmehome_admin/services/animal_applications_provider.dart';
import 'package:flutter/material.dart';

class ApplicationsScreen extends StatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  State<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends State<ApplicationsScreen> {
  final AnimalProvider _animalProvider = AnimalProvider();
  final AnimalApplicationsProvider _applicationProvider =
      AnimalApplicationsProvider();
  final ScrollController _scrollController = ScrollController();
  SearchResult<Animal> _animalResult = SearchResult<Animal>();
  final Map<int, int> _applicationCounts = {};
  final Map<int, bool> _loadingCounts = {};
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

      final data = await _animalProvider.getAdoptable(_searchObject);

      setState(() {
        if (reset) {
          _animalResult = data;
          _applicationCounts.clear();
          _loadingCounts.clear();
        } else {
          _animalResult.result.addAll(data.result);
          _animalResult.count = data.count;
        }
        _hasMore = data.result.length == _searchObject.pageSize;
        _isLoading = false;
      });

      _loadApplicationCounts(data.result);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load animals: ${e.toString()}';
      });
    }
  }

  Future<void> _loadApplicationCounts(List<Animal> animals) async {
    for (final animal in animals) {
      if (animal.animalID != null &&
          !_applicationCounts.containsKey(animal.animalID)) {
        _loadApplicationCount(animal.animalID!);
      }
    }
  }

  Future<void> _loadApplicationCount(int animalId) async {
    if (_loadingCounts[animalId] == true) return;

    setState(() {
      _loadingCounts[animalId] = true;
    });

    try {
      final count = await _applicationProvider.getApplicationCount(animalId);
      setState(() {
        _applicationCounts[animalId] = count;
        _loadingCounts[animalId] = false;
      });
    } catch (e) {
      setState(() {
        _applicationCounts[animalId] = 0;
        _loadingCounts[animalId] = false;
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        backButton: true,
        titleText: 'applications'.toUpperCase(),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name',
                    labelText: 'Search',
                    hintStyle: const TextStyle(color: Colors.white),
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.white,
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
              ),
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20.0,
                      runSpacing: 20.0,
                      children: [
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
                          const Center(
                            child: Text(
                              'No animals found',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        else
                          ...List.generate(
                            _animalResult.result.length + (_hasMore ? 1 : 0),
                            (index) {
                              if (index >= _animalResult.result.length) {
                                return _buildLoader();
                              }
                              final animal = _animalResult.result[index];
                              return _buildAnimalCard(animal);
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildAnimalCard(Animal animal) {
    final animalId = animal.animalID;
    final isLoadingCount = _loadingCounts[animalId] == true;
    final applicationCount = _applicationCounts[animalId];

    return Stack(
      children: [
        AnimalWindowWidget(
          animalImageUrl: animal.animalImage,
          animalName: animal.name ?? 'Unknown',
          onTap: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AnimalApplicationsScreen(animal: animal),
              ),
            );
          },
          animalAge: '',
          shelterCity: '',
        ),
        if (animalId != null)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: isLoadingCount
                  ? const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      '${applicationCount ?? 0}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
      ],
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
