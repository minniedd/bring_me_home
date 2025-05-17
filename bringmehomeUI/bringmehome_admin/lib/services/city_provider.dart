import 'package:bringmehome_admin/models/city.dart';
import 'package:bringmehome_admin/services/base_provider.dart';

class CityProvider extends BaseProvider<City> {
  CityProvider() : super("api/City");

  @override
  City fromJson(data) {
    return City.fromJson(data);
  }

  Future<List<City>> getCities() async {
    try {
      final List<City> cities = await super.getAll(endpointOverride: "all");

      return cities;
    } catch (e) {
      print('Error fetching cities using getList: $e');
      rethrow;
    }
  }
}
