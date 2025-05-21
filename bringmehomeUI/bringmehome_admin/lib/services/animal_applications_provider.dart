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
}
