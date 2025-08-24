import 'package:bringmehome_admin/models/animal.dart';
import 'package:bringmehome_admin/models/search_objects/animal_search_object.dart';
import 'package:bringmehome_admin/models/search_result.dart';
import 'package:bringmehome_admin/services/base_provider.dart';
import 'package:flutter/foundation.dart';

class AnimalProvider extends BaseProvider<Animal> {
  AnimalProvider() : super("api/Animal");

  @override
  Animal fromJson(data) {
    return Animal.fromJson(data);
  }

  Future<SearchResult<Animal>> search(AnimalSearchObject searchObject) async {
    return await get(filter: searchObject);
  }

  Future<SearchResult<Animal>> getAdoptable(AnimalSearchObject? searchObject) async {
    return await get(
      filter: searchObject,
      endpointOverride: "api/Animal/get-available",
    );
  }

  Future<Animal> updateAnimal(int id, dynamic request) async {
    try {
      if (kDebugMode) print('Calling update for animal ID: $id with data: $request');
      return await super.update(id, request);
    } catch (e) {
      if (kDebugMode) print('Error updating animal ID $id: $e');
      rethrow;
    }
  }

  Future<bool> deleteAnimal(int id) async {
    try {
      if (kDebugMode) print('Calling delete for animal ID: $id');
      return await super.delete(id);
    } catch (e) {
      if (kDebugMode) print('Error deleting animal ID $id: $e');
      rethrow;
    }
  }

  Future<Animal> addAnimal(dynamic request) async {
    try {
      if (kDebugMode) print('Calling add for animal with data: $request');
      return await super.insert(request);
    } catch (e) {
      if (kDebugMode) print('Error adding animal: $e');
      rethrow;
    }
  }
}
