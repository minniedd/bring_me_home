import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:learning_app/models/shelter.dart';
import 'package:learning_app/models/user.dart';
import 'package:learning_app/providers/review_provider.dart';
import 'package:learning_app/providers/shelter_provider.dart';
import 'package:learning_app/providers/user_provider.dart';
import 'package:learning_app/screens/reviews_list_screen.dart';
import 'package:learning_app/widgets/master_screen.dart';

class AddReviewScreen extends StatefulWidget {
  const AddReviewScreen({super.key});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  late ReviewProvider _reviewProvider;
  late UserProvider _userProvider;
  late ShelterProvider _shelterProvider;
  User? _loggedInUser;
  bool _isLoadingUser = true;
  bool _isSubmittingReview = false;

  final _commentController = TextEditingController();

  List<Shelter> _shelters = [];
  int? _selectedShelterId;
  double _rating = 0.0;
  bool _isLoadingShelters = true;

  @override
  void initState() {
    super.initState();
    _reviewProvider = ReviewProvider();
    _userProvider = UserProvider();
    _shelterProvider = ShelterProvider();
    _loadUserData();
    _loadShelters();
  }

  Future<void> _loadShelters() async {
    setState(() {
      _isLoadingShelters = true;
    });
    try {
      _shelters = await _shelterProvider.getShelters();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load shelters: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingShelters = false;
        });
      }
    }
  }

  Future<void> _loadUserData() async {
    try {
      await _userProvider.loadCurrentUser();
      _loggedInUser = _userProvider.currentUser;

      if (_loggedInUser == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load user data. Cannot apply.'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error while loading user data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingUser = false;
        });
      }
    }
  }

  Future<void> submitReview({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
    required User? loggedInUser,
    required int? selectedShelterId,
    required double rating,
    required TextEditingController commentController,
    required ReviewProvider reviewProvider,
    required void Function(bool) setSubmitting,
  }) async {
    if (!_validateInputs(
      context,
      formKey,
      loggedInUser,
      selectedShelterId,
      rating,
    )) {
      return;
    }

    setSubmitting(true);

    try {
      await reviewProvider.createReview(
        userId: loggedInUser!.id!,
        shelterId: selectedShelterId!,
        rating: rating.toInt(),
        comment: commentController.text.trim(),
      );

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ReviewListScreen()),
        );
      }
    } on DioException catch (e) {
      _showErrorSnackbar(
        context,
        e.response?.data['message'] ??
            e.message ??
            'Error while submitting review',
      );
    } catch (e) {
      _showErrorSnackbar(context, 'Error while submitting review');
    } finally {
      setSubmitting(false);
    }
  }

  bool _validateInputs(
    BuildContext context,
    GlobalKey<FormState> formKey,
    User? loggedInUser,
    int? selectedShelterId,
    double rating,
  ) {
    if (!formKey.currentState!.validate()) return false;

    if (selectedShelterId == null) {
      _showErrorSnackbar(context, 'Please select a shelter');
      return false;
    }

    if (rating == 0.0) {
      _showErrorSnackbar(context, 'Please select your rating');
      return false;
    }

    if (loggedInUser?.id == null) {
      _showErrorSnackbar(
        context,
        'User data not available. Please log in again',
      );
      return false;
    }

    return true;
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      settingsIcon: true,
      titleText: 'ADD REVIEW',
      child: _isLoadingUser
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      // dropdown w shelters
                      _isLoadingShelters
                          ? const Center(child: CircularProgressIndicator())
                          : DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromRGBO(149, 117, 205, 1))),
                                labelText: 'Shelter',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                              ),
                              hint: const Text("Please pick a shelter"),
                              value: _selectedShelterId,
                              items: _shelters.map((Shelter shelter) {
                                return DropdownMenuItem<int>(
                                  value: shelter.shelterID,
                                  child: Text(shelter.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedShelterId = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please pick a shelter';
                                }
                                return null;
                              },
                            ),
                      const SizedBox(height: 20),

                      // review text
                      TextFormField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(149, 117, 205, 1))),
                          hintText: 'Leave a review',
                          labelText: 'Comment',
                          hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your review.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      // stars
                      const Text("Rating:", style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 8),
                      RatingBar.builder(
                        initialRating: _rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                        },
                      ),
                      const SizedBox(height: 30),

                      // submit
                      _isSubmittingReview
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () => submitReview(
                                context: context,
                                formKey: _formKey,
                                loggedInUser: _loggedInUser,
                                selectedShelterId: _selectedShelterId,
                                rating: _rating,
                                commentController: _commentController,
                                reviewProvider: _reviewProvider,
                                setSubmitting: (val) =>
                                    setState(() => _isSubmittingReview = val),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(149, 117, 205, 1),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              child: const Text('Add Review',style: TextStyle(color: Colors.white),),
                            ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
