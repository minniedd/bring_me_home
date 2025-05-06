import 'package:dio/dio.dart';
import 'package:learning_app/models/animal.dart';
import 'package:learning_app/providers/base_provider.dart';
import 'package:learning_app/services/auth_service.dart';

class FavouritesProvider extends BaseProvider<Animal> {
  final Dio _dio;
  final String _baseUrl = "http://10.0.2.2:5115/api";

  FavouritesProvider()
      : _dio = Dio(),
        super("api/UserFavoriteAnimal") {
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
  Animal fromJson(data) => Animal.fromJson(data);

  Future<bool> toggleFavorite(int animalId, bool isFavorite) async {
    final url = '$_baseUrl/UserFavoriteAnimal/$animalId/favorite';
    
    final response = await _dio.put(
      url,
      data: {'isFavorite': isFavorite},
      options: Options(validateStatus: (status) => true),
    );

    return response.statusCode == 200 || 
           (response.statusCode == 404 && !isFavorite);
  }

  Future<List<Animal>> getFavorites() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/UserFavoriteAnimal/favorites',
        options: Options(validateStatus: (status) => status! < 500),
      );

      if (response.statusCode != 200) return [];

      return (response.data as List)
          .map((animalJson) => Animal.fromJson(animalJson))
          .toList();
    } catch (_) {
      return [];
    }
  }
}