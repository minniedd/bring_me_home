import 'package:dio/dio.dart';
import 'package:learning_app/models/shelter.dart';
import 'package:learning_app/providers/base_provider.dart';
import 'package:learning_app/services/auth_service.dart';

class ShelterProvider extends BaseProvider<Shelter> {
  final Dio _dio;

  ShelterProvider()
      : _dio = Dio(),
        super("api/Shelter") {
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
  Shelter fromJson(data) {
    return Shelter.fromJson(data);
  }

  Future<List<Shelter>> getShelters() async {
      var result = await get(); 
        return result.result;
  }
}