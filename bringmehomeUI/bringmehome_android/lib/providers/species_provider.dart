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
  Species fromJson(data) {
    return Species.fromJson(data);
  }

  Future<List<Species>> getSpecies() async {
    try {
      final response = await _dio.get(
        '$_baseUrl/Species',
        options: Options(
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        List<dynamic> speciesJsonList = [];

        if (responseData is Map &&
            responseData.containsKey('items') &&
            responseData['items'] is List) {
          speciesJsonList = responseData['items'];
        } else if (responseData is List) {
          speciesJsonList = responseData;
        } else {
          print(
              'Unexpected response type for species: ${responseData.runtimeType}');
          return [];
        }

        return speciesJsonList
            .map((speciesJson) {
              try {
                return fromJson(speciesJson);
              } catch (e) {
                print('Error parsing species JSON: $e');
                print('Error species JSON: $speciesJson');
                return null;
              }
            })
            .where((species) => species != null)
            .cast<Species>()
            .toList();
      } else {
        print('Failed to fetch species - Status: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      print('Error fetching species: ${e.message}');
      if (e.response != null) {
        print('Error response status: ${e.response!.statusCode}');
        print('Error response data: ${e.response!.data}');
      }
      return [];
    } catch (e) {
      print('An unexpected error occurred during species fetching: $e');
      return [];
    }
  }
}
