import 'package:flutter/material.dart';
import 'package:learning_app/models/reviews.dart';
import 'package:learning_app/models/search_objects/review_search_object.dart';
import 'package:learning_app/models/search_result.dart';
import 'package:learning_app/providers/review_provider.dart';
import 'package:learning_app/screens/add_review_screen.dart';
import 'package:learning_app/widgets/master_screen.dart';

class ReviewListScreen extends StatefulWidget {
  const ReviewListScreen({super.key});

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  final ReviewProvider _reviewProvider = ReviewProvider();
  SearchResult<Review> _reviewResult = SearchResult<Review>();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  final ReviewSearchObject _searchObject = ReviewSearchObject();
  var borderRadius = BorderRadius.circular(20);

  @override
  void initState() {
    super.initState();
    _loadReviews();
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
      _loadMoreReviews();
    }
  }

  Future<void> _loadReviews({bool reset = false}) async {
    if (reset) {
      _searchObject.pageNumber = 1;
      _hasMore = true;
    }

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final data = await _reviewProvider.search(_searchObject);

      setState(() {
        if (reset) {
          _reviewResult = data;
        } else {
          _reviewResult.result.addAll(data.result);
          _reviewResult.count = data.count;
        }
        _hasMore = data.result.length == _searchObject.pageSize;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load reviews: ${e.toString()}';
      });
    }
  }

  Future<void> _loadMoreReviews() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _searchObject.pageNumber = (_searchObject.pageNumber ?? 0) + 1;
    });

    await _loadReviews();
  }

  void _handleSearch(String value) {
    _searchObject.fTS = value.isNotEmpty ? value : null;
    _loadReviews(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MasterScreenWidget(
        titleText: 'REVIEWS',
        child: _errorMessage != null
            ? Center(child: Text(_errorMessage!))
            : ListView.builder(
                // Use ListView.builder as the main scrollable
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: _reviewResult.result.length +
                    (_hasMore ? 1 : 0) +
                    1, // +1 for the search bar
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextField(
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
                    );
                  }

                  // Adjust index for the list items
                  final reviewIndex = index - 1;

                  if (reviewIndex >= _reviewResult.result.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final review = _reviewResult.result[reviewIndex];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(borderRadius: borderRadius),
                      tileColor: const Color.fromRGBO(149, 117, 205, 1),
                      title: Text(
                        review.shelterName ?? 'Unknown Shelter',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        review.comment,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${review.rating}/5',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(149, 117, 205, 1),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 70),
          child: FloatingActionButton.extended(
            backgroundColor: const Color.fromARGB(255, 114, 225, 129),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const AddReviewScreen()),
              );
            },
            label: const Text('Add Review'),
            icon: const Icon(Icons.add, color: Colors.white, size: 25),
          )),
    );
  }
}
