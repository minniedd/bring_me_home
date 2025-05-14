import 'package:bringmehome_admin/models/breed.dart';
import 'package:bringmehome_admin/services/base_provider.dart';

class BreedProvider extends BaseProvider<Breed> {
  BreedProvider() : super("api/Breed");

  @override
  Breed fromJson(data) {
    return Breed.fromJson(data);
  }

  Future<List<Breed>> getBreeds() async {
    try {
      final List<Breed> breeds = await super.getAll(endpointOverride: "all");

      return breeds;
    } catch (e) {
      print('Error fetching breeds using getList: $e');
      rethrow;
    }
  }

  Future<List<Breed>> getBreedsBySpecies(int speciesId) async {
    try {
      final List<Breed> breeds = await super.getAll(
        endpointOverride: "species/$speciesId",
      );
      return breeds;
    } catch (e) {
      print('Error fetching breeds by species ID $speciesId: $e');
      rethrow;
    }
  }
}
