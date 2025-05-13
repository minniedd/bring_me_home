import 'package:bringmehome_admin/models/breed.dart';
import 'package:bringmehome_admin/models/search_result.dart';
import 'package:bringmehome_admin/services/base_provider.dart';

class BreedProvider extends BaseProvider<Breed> {
  BreedProvider() : super("api/Breed");

  @override
  Breed fromJson(data) {
    return Breed.fromJson(data);
  }

  Future<List<Breed>> getBreeds() async {
    try {
      final SearchResult<Breed> searchResult = await get();

      return searchResult.result;
    } catch (e) {
      print('Error fetching breeds: $e');
      rethrow;
    }
  }

}