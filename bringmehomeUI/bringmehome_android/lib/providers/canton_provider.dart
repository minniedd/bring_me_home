import 'package:dio/dio.dart';
import 'package:learning_app/models/canton.dart';
import 'package:learning_app/providers/base_provider.dart';
import 'package:learning_app/services/auth_service.dart';

class CantonProvider extends BaseProvider<Canton> {
  final Dio _dio;
  final String _baseUrl = "http://10.0.2.2:5115/api";

  CantonProvider()
      : _dio = Dio(),
        super("api/Canton") {
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
  Canton fromJson(data) {
    return Canton.fromJson(data);
  }

  Future<List<Canton>> getCantons() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/Canton',
        options: Options(validateStatus: (status) => status! < 500),
      );

      if (response.statusCode != 200) {
        return [];
      }

      final responseData = response.data;
      List<dynamic> cantonJsonList = [];

      if (responseData is Map && responseData['items'] is List) {
        cantonJsonList = responseData['items'];
      } else if (responseData is List) {
        cantonJsonList = responseData;
      } else {
        return [];
      }

      return cantonJsonList
          .map((json) {
            try {
              return fromJson(json);
            } catch (_) {
              return null;
            }
          })
          .whereType<Canton>()
          .toList();
    } catch (_) {
      return [];
    }
  }
}
