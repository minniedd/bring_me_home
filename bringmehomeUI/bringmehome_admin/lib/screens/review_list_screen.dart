import 'package:bringmehome_admin/components/master_screen.dart';
import 'package:bringmehome_admin/models/reviews.dart';
import 'package:bringmehome_admin/models/search_objects/review_search_object.dart';
import 'package:bringmehome_admin/models/search_result.dart';
import 'package:bringmehome_admin/services/review_provider.dart';
import 'package:flutter/material.dart';

class ReviewListScreen extends StatefulWidget {
  const ReviewListScreen({super.key});

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  var borderRadius = BorderRadius.circular(20);
  final ReviewProvider _reviewProvider = ReviewProvider();
  final ScrollController _scrollController = ScrollController();
  SearchResult<Review> _reviewList = SearchResult<Review>();
  bool _isLoading = false;
  bool _hasMore = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  final ReviewSearchObject _searchObject = ReviewSearchObject();

  @override
  void initState() {
    super.initState();
    _loadReviews();
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
          _reviewList = data;
        } else {
          _reviewList.result.addAll(data.result);
          _reviewList.count = data.count;
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
      _searchObject.pageNumber = (_searchObject.pageNumber ?? 1) + 1;
    });

    await _loadReviews();
  }

  void _handleSearch(String value) {
    _searchObject.fTS = value.isNotEmpty ? value : null;
    _loadReviews(reset: true);
  }

  void _deleteReview(int id) {
    _reviewProvider.deleteReview(id).then((_) {
      _loadReviews(reset: true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review deleted successfully!')),
      );
    }).catchError((error) {
      print('Error deleting review: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete review: ${error.toString()}')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MasterScreenWidget(
        backButton: true,
        titleText: 'REVIEWS',
        child: _errorMessage != null
            ? Center(child: Text(_errorMessage!))
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8.0),
                itemCount: _reviewList.result.length + (_hasMore ? 1 : 0) + 1,
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
                  final reviewIndex = index - 1;

                  if (reviewIndex >= _reviewList.result.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final review = _reviewList.result[reviewIndex];
                  return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ListTile(
                        shape:
                            RoundedRectangleBorder(borderRadius: borderRadius),
                        tileColor: const Color.fromRGBO(255, 255, 255, 1),
                        title: Text(
                          review.shelterName ?? 'Unknown Shelter',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(149, 117, 205, 1),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'By: ${review.user?.firstName} ${review.user?.lastName}',
                              style: const TextStyle(
                                color: Color.fromRGBO(154, 126, 202, 1),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              review.comment,
                              style: const TextStyle(
                                  color: Color.fromRGBO(82, 59, 121, 1)),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(149, 117, 205, 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${review.rating}/5',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 205, 117, 117),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Confirm Deletion'),
                                      content: const Text(
                                          'Are you sure you want to delete review?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _deleteReview(review.reviewID!);
                                          },
                                          child: const Text(
                                            'Delete',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                tooltip: 'Delete Review',
                              ),
                            ),
                          ],
                        ),
                      ));
                },
              ),
      ),
    );
  }
}
