import 'package:dio/dio.dart';
import 'package:learning_app/models/reviews.dart';
import 'package:learning_app/models/search_objects/review_search_object.dart';
import 'package:learning_app/models/search_result.dart';
import 'package:learning_app/providers/base_provider.dart';
import 'package:learning_app/services/auth_service.dart';

class ReviewProvider extends BaseProvider<Review> {
  final Dio _dio;
  static const String _applicationEndpoint = '/Review';

  ReviewProvider()
      : _dio = Dio(),
        super("api/Review") {
    _dio.options.headers["Content-Type"] = "application/json";
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await AuthService.getAccessToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
    ));
  }

  @override
  Review fromJson(data) {
    return Review.fromJson(data);
  }

  Future<SearchResult<Review>> search(ReviewSearchObject searchObject) async {
    return await get(filter: searchObject);
  }

  Future<void> createReview({
    required int userId,
    required int shelterId,
    required int rating,
    required String comment,
  }) async {
    final requestData = {
      'userID': userId,
      'shelterID': shelterId,
      'rating': rating,
      'comment': comment,
    };

    final url = "${BaseProvider.baseUrl}$endpoint";
    final response = await _dio.post(url, data: requestData);

    if (response.statusCode == null || response.statusCode! >= 300) {
      throw _parseErrorResponse(response);
    }
  }

  @override
  Future<Review> insert(dynamic request) async {
    final url = "${BaseProvider.baseUrl}$_applicationEndpoint";
    final response = await _dio.post(url, data: request);

    if (response.statusCode == null || response.statusCode! >= 300) {
      throw _parseErrorResponse(response);
    }

    return fromJson(response.data);
  }

  Exception _parseErrorResponse(Response response) {
    final statusCode = response.statusCode ?? 'N/A';
    String errorMessage = response.statusMessage ?? "Request failed";

    if (response.data is Map<String, dynamic>) {
      if (response.data['message'] != null) {
        errorMessage = response.data['message'];
      } else if (response.data['title'] != null) {
        errorMessage = response.data['title'];
      } else if (response.data['errors'] != null) {
        final errors = response.data['errors'] as Map<String, dynamic>;
        errorMessage = errors.entries
            .map((e) =>
                e.value is List ? e.value.join(', ') : e.value.toString())
            .join(', ');
      }
    } else if (response.data is String) {
      errorMessage = response.data;
    }

    return Exception("Request failed ($statusCode): $errorMessage");
  }
}
