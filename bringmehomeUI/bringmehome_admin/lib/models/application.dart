import 'package:bringmehome_admin/models/animal.dart';
import 'package:bringmehome_admin/models/application_status.dart';
import 'package:bringmehome_admin/models/staff.dart';
import 'package:bringmehome_admin/models/user.dart';

class AnimalApplication {
  final int? applicationID;
  final int userID;
  final String? userFullName;
  final int animalID;
  final DateTime? applicationDate; 
  final int statusID; 
  late String? notes; 
  final String? livingSituation;
  final String? isAnimalAllowed; 
  final int? reasonId;
  final String? reasonName;
  final int? reviewedByStaffID; 
  final DateTime? reviewDate;

  final User? user; 
  final Animal? animal;
  final ApplicationStatus? status;
  final String? statusName;
  late Staff? reviewedBy; 

  AnimalApplication.create({
    required this.userID,
    required this.animalID,
    this.notes,
    this.livingSituation,
    this.isAnimalAllowed,
    this.reasonId,
    this.applicationID,
    this.applicationDate,
    this.statusID = 1, 
    this.reviewedBy,
    this.status,
    this.statusName,
    this.user, 
    this.animal,
    this.userFullName,
    this.reasonName,
    this.reviewedByStaffID,
    this.reviewDate,
  });

  factory AnimalApplication.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    final animalJson = json['animal'];
    final reviewedByJson = json['reviewedBy']; 

    return AnimalApplication(
      applicationID: json['applicationID'] as int?,
      userID: json['userID'] as int,
      userFullName: json['userFullName'] as String?,
      animalID: json['animalID'] as int,
      applicationDate: json['applicationDate'] != null
          ? DateTime.parse(json['applicationDate'] as String)
          : null,
      statusID: json['statusID'] as int,
      notes: json['notes'] as String?,
      livingSituation: json['livingSituation'] as String?,
      isAnimalAllowed: json['isAnimalAllowed'] as String?,
      statusName: json['statusName'] as String?,
      reasonId: json['reasonId'] as int?,
      reasonName: json['reasonName'] as String?,
      reviewedByStaffID: json['reviewedByStaffID'] as int?, 
      reviewDate: json['reviewDate'] != null
          ? DateTime.parse(json['reviewDate'] as String)
          : null,
      user: (userJson is Map<String, dynamic>) ? User.fromJson(userJson) : null,
      animal: (animalJson is Map<String, dynamic>) ? Animal.fromJson(animalJson) : null,
      status: json['statusName'] != null
          ? ApplicationStatus(statusID: json['statusID'] as int, statusName: json['statusName'] as String)
          : null,
      reviewedBy: (reviewedByJson is Map<String, dynamic>) ? Staff.fromJson(reviewedByJson) : null,
    );
  }

  AnimalApplication({
      this.applicationID,
      required this.userID,
      this.userFullName,
      required this.animalID,
      this.applicationDate,
      required this.statusID,
      this.notes,
      this.livingSituation,
      this.isAnimalAllowed,
      this.reasonId,
      this.user,
      this.statusName,
      this.animal,
      this.status,
      this.reviewedBy,
      this.reasonName,
      this.reviewedByStaffID, 
      this.reviewDate,
  });

  Map<String, dynamic> toJson() {
    return {
      if(applicationID != null) 'applicationID': applicationID,
      'userID': userID,
      'userFullName':userFullName,
      'animalID': animalID,
      if(applicationDate != null) 'applicationDate': applicationDate!.toIso8601String(), 
      'statusID': statusID,
      if(statusName != null) 'statusName': statusName,       
      'notes': notes,
      'livingSituation': livingSituation,
      'isAnimalAllowed': isAnimalAllowed,
      'reasonId': reasonId, 
      'reasonName':reasonName,
      if(reviewedByStaffID != null) 'reviewedByStaffID': reviewedByStaffID, 
      if(reviewDate != null) 'reviewDate': reviewDate!.toIso8601String(),
    };
  }
}