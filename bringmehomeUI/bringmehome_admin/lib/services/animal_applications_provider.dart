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
      final List<AnimalApplication> applications = (await super.get()) as List<AnimalApplication>;

      return applications;
    } catch (e) {
      print('Error fetching applications using getList: $e');
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
      print('Error fetching applications by animals ID $animalId: $e');
      rethrow;
    }
  }
}
