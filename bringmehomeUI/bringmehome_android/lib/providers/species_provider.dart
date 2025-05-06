import 'package:dio/dio.dart';
import 'package:learning_app/models/species.dart';
import 'package:learning_app/providers/base_provider.dart';
import 'package:learning_app/services/auth_service.dart';

class SpeciesProvider extends BaseProvider<Species> {
  final Dio _dio;
  final String _baseUrl = "http://10.0.2.2:5115/api";

  SpeciesProvider()
      : _dio = Dio(),
        super("api/Species") {
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
  Species fromJson(data) => Species.fromJson(data);

  Future<List<Species>> getSpecies() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/Species',
        options: Options(validateStatus: (status) => status! < 500),
      );

      if (response.statusCode != 200) return [];

      final responseData = response.data;
      final speciesJsonList = responseData is Map && responseData['items'] is List
          ? responseData['items'] as List
          : responseData is List
              ? responseData
              : [];

      return speciesJsonList
          .map((json) {
            try {
              return fromJson(json);
            } catch (_) {
              return null;
            }
          })
          .whereType<Species>()
          .toList();
    } catch (_) {
      return [];
    }
  }
}