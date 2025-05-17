import 'package:bringmehome_admin/models/staff.dart';
import 'package:bringmehome_admin/models/user.dart';
import 'package:bringmehome_admin/services/staff_provider.dart';
import 'package:bringmehome_admin/services/user_provider.dart';

class StaffRegistrationService {
  final UserProvider _userProvider;
  final StaffProvider _staffProvider;

  StaffRegistrationService({
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
  }) async {
    try {
      final createdUser = await _userProvider.insert({
        ...user.toJson(),
        if (password != null) 'password': password,
      });

      final staff = await _staffProvider.insert({
        'userID': createdUser.id,
        'position': position,
        'department': department,
        'shelterID': shelterID,
        'hireDate': hireDate.toIso8601String(),
        'status': status,
        'accessLevel': accessLevel,
      });

      return staff;
    } catch (e) {
      print('Error registering staff with user: $e');
      rethrow;
    }
  }
}