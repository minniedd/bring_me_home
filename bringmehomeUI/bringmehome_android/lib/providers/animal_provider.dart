import 'package:learning_app/models/animal.dart';
import 'package:learning_app/models/search_objects/animal_search_object.dart';
import 'package:learning_app/models/search_result.dart';
import 'package:learning_app/providers/base_provider.dart';

class AnimalProvider extends BaseProvider<Animal> {
  AnimalProvider() : super("api/Animal");

  @override
  Animal fromJson(data) {
    return Animal.fromJson(data);
  }

  Future<SearchResult<Animal>> search(AnimalSearchObject searchObject) async {
  return await get(filter: searchObject);
}
}