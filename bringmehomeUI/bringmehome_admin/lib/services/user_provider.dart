import 'package:bringmehome_admin/models/search_objects/user_search_object.dart';
import 'package:bringmehome_admin/models/search_result.dart';
import 'package:bringmehome_admin/models/user.dart';
import 'package:bringmehome_admin/services/base_provider.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider() : super("api/User");

  @override
  User fromJson(data) {
    return User.fromJson(data);
  }

  Future<SearchResult<User>> search(UserSearchObject searchObject) async {
    return await get(filter: searchObject);
  }

  Future<List<User>> getAdopters() async {
    try {
      final List<User> users = await super.getAll(endpointOverride: "adopters");

      return users;
    } catch (e) {
      print('Error fetching adopters using getList: $e');
      rethrow;
    }
  }

  Future<User> getById(int id) async {
    return await getById(id);
  }

  Future<bool> deleteUser(int id) async {
    try {
      if (kDebugMode) print('Calling delete for user ID: $id');
      return await super.delete(id);
    } catch (e) {
      if (kDebugMode) print('Error deleting user ID $id: $e');
      rethrow;
    }
  }

  Future<User> updateUser(int id, dynamic request) async {
    try {
      if (kDebugMode)
        print('Calling update for user ID: $id with data: $request');
      return await super.update(id, request);
    } catch (e) {
      if (kDebugMode) print('Error updating user ID $id: $e');
      rethrow;
    }
  }
}
