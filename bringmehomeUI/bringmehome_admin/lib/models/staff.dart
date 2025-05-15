import 'package:bringmehome_admin/models/user.dart';

class Staff {
  final int staffID;
  final int userID;
  final String position;
  final String department;
  final int shelterID;
  final DateTime hireDate;
  final String status;
  final int accessLevel;
  final User? user;

  Staff({
    required this.staffID,
    required this.userID,
    required this.position,
    required this.department,
    required this.shelterID,
    required this.hireDate,
    required this.status,
    required this.accessLevel,
    this.user,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      staffID: json['staffID'] as int,
      userID: json['userID'] as int,
      position: json['position'] as String,
      department: json['department'] as String,
      shelterID: json['shelterID'] as int,
      hireDate: DateTime.parse(json['hireDate'] as String),
      status: json['status'] as String,
      accessLevel: json['accessLevel'] as int,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'staffID': staffID,
      'userID': userID,
      'position': position,
      'department': department,
      'shelterID': shelterID,
      'hireDate': hireDate.toIso8601String(),
      'status': status,
      'accessLevel': accessLevel,
      'user': user?.toJson(),
    };
  }

  @override
  String toString() {
    return 'Staff(staffID: $staffID, userID: $userID, position: $position, department: $department, shelterID: $shelterID, hireDate: $hireDate, status: $status, accessLevel: $accessLevel)';
  }
}