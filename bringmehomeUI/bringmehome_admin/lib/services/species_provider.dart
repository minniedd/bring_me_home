import 'package:bringmehome_admin/models/species.dart';
import 'package:bringmehome_admin/services/base_provider.dart';

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
      print('Error fetching species using getList: $e');
      rethrow;
    }
  }
}
