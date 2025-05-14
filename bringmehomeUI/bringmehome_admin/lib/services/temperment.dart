import 'package:bringmehome_admin/models/temperment.dart';
import 'package:bringmehome_admin/services/base_provider.dart';

class TempermentProvider extends BaseProvider<Temperment> {
  TempermentProvider() : super("api/AnimalTemperment");

  @override
  Temperment fromJson(data) {
    return Temperment.fromJson(data);
  }

  Future<List<Temperment>> getTemperments() async {
    try {
      final List<Temperment> temperaments =
          await super.getAll(endpointOverride: "all");

      return temperaments;
    } catch (e) {
      print('Error fetching temperaments using getList: $e');
      rethrow;
    }
  }
}
