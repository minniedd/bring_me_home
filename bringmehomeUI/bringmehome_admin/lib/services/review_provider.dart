import 'package:bringmehome_admin/models/reviews.dart';
import 'package:bringmehome_admin/models/search_objects/review_search_object.dart';
import 'package:bringmehome_admin/models/search_result.dart';
import 'package:bringmehome_admin/services/base_provider.dart';
import 'package:flutter/foundation.dart';

class ReviewProvider extends BaseProvider<Review> {
  ReviewProvider() : super("api/Review");

  @override
  Review fromJson(data) {
    return Review.fromJson(data);
  }

  Future<SearchResult<Review>> search(ReviewSearchObject searchObject) async {
    return await get(filter: searchObject);
  }

  Future<bool> deleteReview(int id) async {
    try {
      if (kDebugMode) print('Calling delete for animal ID: $id');
      return await super.delete(id);
    } catch (e) {
      if (kDebugMode) print('Error deleting animal ID $id: $e');
      rethrow;
    }
  }
}