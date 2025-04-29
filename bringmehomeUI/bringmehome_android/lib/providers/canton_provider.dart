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
      onError: (DioException e, handler) async {
        print('Dio Error: ${e.message}');
        if (e.response != null) {
          print('Error Response Status: ${e.response!.statusCode}');
          print('Error Response Data: ${e.response!.data}');
        }
        return handler.next(e);
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
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        List<dynamic> cantonJsonList = [];

        if (responseData is Map &&
            responseData.containsKey('items') &&
            responseData['items'] is List) {
          cantonJsonList = responseData['items'];
        } else if (responseData is List) {
          cantonJsonList = responseData;
        } else {
          print(
              'Unexpected response type for cantons: ${responseData.runtimeType}');
          return [];
        }

        return cantonJsonList
            .map((cantonJson) {
              try {
                return fromJson(cantonJson);
              } catch (e) {
                print('Error parsing canton JSON: $e');
                print('Error canton JSON: $cantonJson');
                return null;
              }
            })
            .where((cantons) => cantons != null)
            .cast<Canton>()
            .toList();
      } else {
        print('Failed to fetch cantons - Status: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      print('Error fetching cantons: ${e.message}');
      if (e.response != null) {
        print('Error response status: ${e.response!.statusCode}');
        print('Error response data: ${e.response!.data}');
      }
      return [];
    } catch (e) {
      print('An unexpected error occurred during cantons fetching: $e');
      return [];
    }
  }
}
