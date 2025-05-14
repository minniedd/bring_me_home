import 'package:bringmehome_admin/models/animal_status.dart';
import 'package:bringmehome_admin/services/base_provider.dart';

class AnimalStatusProvider extends BaseProvider<AnimalStatus> {
  AnimalStatusProvider() : super("api/AnimalStatus");

  @override
  AnimalStatus fromJson(data) {
    return AnimalStatus.fromJson(data);
  }

  Future<List<AnimalStatus>> getAnimalStatus() async {
    try {
      final List<AnimalStatus> statuses = await super.getAll(endpointOverride: "all");

      return statuses;
    } catch (e) {
      print('Error fetching statuses using getList: $e');
      rethrow;
    }
  }
}