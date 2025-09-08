import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bringmehome_admin/models/application.dart';
import 'package:bringmehome_admin/services/base_provider.dart';

class AnimalApplicationsProvider extends BaseProvider<AnimalApplication> {
  AnimalApplicationsProvider() : super("api/AdoptionApplication");

  @override
  AnimalApplication fromJson(data) {
    return AnimalApplication.fromJson(data);
  }

  Future<List<AnimalApplication>> getApplications() async {
    try {
      final List<AnimalApplication> applications =
          (await super.get()) as List<AnimalApplication>;

      return applications;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AnimalApplication>> getApplicationByAnimal(int animalId) async {
    try {
      final List<AnimalApplication> applications = await super.getAll(
        endpointOverride: "animal/$animalId",
      );
      return applications;
    } catch (e) {
      rethrow;
    }
  }

  Future<AnimalApplication> reject(AnimalApplication request) async {
    try {
      return await put(endpointOverride: "Reject", request: request);
    } catch (e) {
      rethrow;
    }
  }

  Future<AnimalApplication> approve(AnimalApplication request) async {
    try {
      return await put(endpointOverride: "Approve", request: request);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getApplicationCount(int animalId) async {
    var url =
        "${BaseProvider.baseUrl}api/AdoptionApplication/GetApplicationCount/$animalId";
    var uri = Uri.parse(url);
    var headers = await createHeaders();

    try {
      var response = await http.get(uri, headers: headers);

      if (isValidResponse(response)) {
        final directParse = int.tryParse(response.body.trim());
        if (directParse != null) return directParse;
        try {
          final decoded = jsonDecode(response.body);
          return _extractInt(decoded);
        } catch (e) {
          return 0;
        }
      } else {
        throw Exception(
            "Failed to get application count: ${response.statusCode}");
      }
    } catch (e) {
      return 0;
    }
  }

  int _extractInt(dynamic payload) {
    if (payload == null) return 0;
    if (payload is int) return payload;
    if (payload is num) return payload.toInt();

    if (payload is Map<String, dynamic>) {
      if (payload.containsKey('value')) {
        return (payload['value'] as num?)?.toInt() ?? 0;
      }
      if (payload.containsKey('data')) {
        return _extractInt(payload['data']);
      }
      if (payload.containsKey('result')) {
        return _extractInt(payload['result']);
      }
      if (payload.containsKey('count')) {
        return (payload['count'] as num?)?.toInt() ?? 0;
      }
    }
    return 0;
  }
}
