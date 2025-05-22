
import 'package:learning_app/models/shelter.dart';
import 'package:learning_app/providers/base_provider.dart';

class ShelterProvider extends BaseProvider<Shelter> {
  ShelterProvider() : super("api/Shelter");

  @override
  Shelter fromJson(data) {
    return Shelter.fromJson(data);
  }

  Future<List<Shelter>> getShelters() async {
    try {
      final List<Shelter> shelters = await super.getAll(endpointOverride: "all");

      return shelters;
    } catch (e) {
      rethrow;
    }
  }
}