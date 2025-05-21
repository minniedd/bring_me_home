import 'package:bringmehome_admin/models/staff.dart';
import 'package:bringmehome_admin/models/user_staff.dart';
import 'package:bringmehome_admin/services/base_provider.dart';
import 'package:flutter/foundation.dart';

class StaffProvider extends BaseProvider<Staff> {
  StaffProvider() : super("api/Staff");

  @override
  Staff fromJson(data) {
    return Staff.fromJson(data);
  }

  Future<List<Staff>> getStaff() async {
    try {
      final List<Staff> staff = await super.getAll(endpointOverride: "all");

      return staff;
    } catch (e) {
      print('Error fetching staff using getList: $e');
      rethrow;
    }
  }

  Future<Staff> getStaffById(int id) async {
    try {
      if (kDebugMode) print('Calling get for staff ID: $id');
      return await super.getById(id);
    } catch (e) {
      if (kDebugMode) print('Error fetching staff ID $id: $e');
      rethrow;
    }
  }

  Future<bool> deleteStaff(int id) async {
    try {
      if (kDebugMode) print('Calling delete for staff ID: $id');
      return await super.delete(id);
    } catch (e) {
      if (kDebugMode) print('Error deleting staff ID $id: $e');
      rethrow;
    }
  }

  Future<Staff> addStaff(dynamic request) async {
    try {
      if (kDebugMode) print('Calling add for staff with data: $request');
      return await super.insert(request);
    } catch (e) {
      if (kDebugMode) print('Error adding staff: $e');
      rethrow;
    }
  }

  Future<Staff> updateStaff(int id, dynamic request) async {
    try {
      if (kDebugMode) print('Calling update for staff ID: $id with data: $request');
      return await super.update(id, request);
    } catch (e) {
      if (kDebugMode) print('Error updating staff ID $id: $e');
      rethrow;
    }
  }

  Future<Staff> createUserAndAddToStaff(UserStaff userStaff) async {
    try {
      if (kDebugMode) print('Creating user: ${userStaff.firstName} ${userStaff.lastName}');
      
      var userData = userStaff.userToJson();
      final userResponse = await super.insert(userData);
      
      final int userId = userResponse.userID;
      if (userId == 0) {
        throw Exception('Failed to get valid user ID from user creation response');
      }
      
      if (kDebugMode) print('User created with ID: $userId');
      
      userStaff.userID = userId;
      if (kDebugMode) print('Adding user to staff with position: ${userStaff.position}');
      
      var staffData = userStaff.staffToJson();
      final staffResponse = await super.insert(staffData);
      
      return staffResponse;
    } catch (e) {
      if (kDebugMode) print('Error creating user and adding to staff: $e');
      rethrow;
    }
  }

}