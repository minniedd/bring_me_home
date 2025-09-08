import 'package:bringmehome_admin/models/staff.dart';
import 'package:bringmehome_admin/models/user.dart';
import 'package:bringmehome_admin/services/staff_provider.dart';
import 'package:bringmehome_admin/services/user_provider.dart';
import 'package:flutter/foundation.dart';

class UserStaffProvider {
  final UserProvider _userProvider;
  final StaffProvider _staffProvider;

  UserStaffProvider({
    required UserProvider userProvider,
    required StaffProvider staffProvider,
  })  : _userProvider = userProvider,
        _staffProvider = staffProvider;

  Future<Staff> registerStaffWithUser({
    required User user,
    required String position,
    required String department,
    required int shelterID,
    required DateTime hireDate,
    required String status,
    required int accessLevel,
    String? password,
    String? userImage,
  }) async {
    try {
      final createdUser = await _userProvider.insert({
        ...user.toJson(),
        if (password != null) 'password': password,
        if (userImage != null) 'userImage': userImage,
      });

      final staff = await _staffProvider.insert({
        'userID': createdUser.id,
        'position': position,
        'department': department,
        'shelterID': shelterID,
        'hireDate': hireDate.toIso8601String(),
        'status': status,
        'accessLevel': accessLevel,
        if (userImage != null) 'staffImage': userImage,
      });

      return staff;
    } catch (e) {
      print('Error registering staff with user: $e');
      rethrow;
    }
  }

  Future<Staff> updateStaffWithUser({
    required int staffId,
    required int userId,
    User? user,
    String? position,
    String? department,
    int? shelterID,
    DateTime? hireDate,
    String? status,
    int? accessLevel,
    String? password,
    String? userImage,
  }) async {
    try {
      if (user != null || password != null || userImage != null) {
        final userUpdateData = <String, dynamic>{};

        if (user != null) {
          userUpdateData.addAll(user.toJson());
        }

        if (password != null) {
          userUpdateData['password'] = password;
        }

        if (userImage != null) {
          userUpdateData['userImage'] = userImage;
        }

        if (userUpdateData.isNotEmpty) {
          await _userProvider.update(userId, userUpdateData);
        }
      }

      final staffUpdateData = <String, dynamic>{};

      staffUpdateData['userID'] = userId;
      if (position != null) staffUpdateData['position'] = position;
      if (department != null) staffUpdateData['department'] = department;
      if (shelterID != null) staffUpdateData['shelterID'] = shelterID;
      if (hireDate != null) {
        staffUpdateData['hireDate'] = hireDate.toIso8601String();
      }
      if (status != null) staffUpdateData['status'] = status;
      if (accessLevel != null) staffUpdateData['accessLevel'] = accessLevel;
      if (userImage != null) staffUpdateData['staffImage'] = userImage;

      Staff updatedStaff;
      if (staffUpdateData.isNotEmpty) {
        updatedStaff =
            await _staffProvider.updateStaff(staffId, staffUpdateData);
      } else {
        updatedStaff = await _staffProvider.getStaffById(staffId);
      }

      return updatedStaff;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating staff with user: $e');
      }
      rethrow;
    }
  }
}
