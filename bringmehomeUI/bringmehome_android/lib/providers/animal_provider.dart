import 'package:learning_app/models/animal.dart';
import 'package:learning_app/models/search_objects/animal_search_object.dart';
import 'package:learning_app/models/search_result.dart';
import 'package:learning_app/providers/base_provider.dart';
import 'package:dio/dio.dart';
import 'package:learning_app/services/auth_service.dart';

class AnimalProvider extends BaseProvider<Animal> {
  final Dio _dio;

  AnimalProvider()
      : _dio = Dio(),
        super("api/Animal") {
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
  Animal fromJson(data) {
    return Animal.fromJson(data);
  }

  Future<SearchResult<Animal>> search(AnimalSearchObject searchObject) async {
    return await get(filter: searchObject);
  }

}
