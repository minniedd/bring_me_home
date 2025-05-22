import 'package:learning_app/models/species.dart';
import 'package:learning_app/providers/base_provider.dart';

class SpeciesProvider extends BaseProvider<Species> {
  SpeciesProvider() : super("api/Species");

  @override
  Species fromJson(data) {
    return Species.fromJson(data);
  }

  Future<List<Species>> getSpecies() async {
    try {
      final List<Species> species = await super.getAll(endpointOverride: "all");

      return species;
    } catch (e) {
      rethrow;
    }
  }
}