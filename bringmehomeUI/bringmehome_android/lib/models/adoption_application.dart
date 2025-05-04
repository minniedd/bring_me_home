import 'package:learning_app/models/User.dart';
import 'package:learning_app/models/animal.dart';
import 'package:learning_app/models/application_status.dart';

class AdoptionApplication {
  final int? applicationID;
  final int userID;
  final int animalID;
  final DateTime? applicationDate; 
  final int statusID; 
  final String? notes; 
  final String? livingSituation;
  final bool? isAnimalAllowed; 
  final int? reasonId;

  final User? user; 
  final Animal? animal;
  final ApplicationStatus? status;
  final User? reviewedBy; 

  AdoptionApplication.create({
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
    this.user, 
    this.animal,
  });


  factory AdoptionApplication.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    final animalJson = json['animal'];
    final statusJson = json['status'];
    final reviewedByJson = json['reviewedBy']; 

    return AdoptionApplication(
      applicationID: json['applicationID'] as int, 
      userID: json['userID'] as int, 
      animalID: json['animalID'] as int,
      applicationDate: json['applicationDate'] != null
          ? DateTime.parse(json['applicationDate'] as String)
          : null,
      statusID: json['statusID'] as int,
      notes: json['notes'] as String?,
      livingSituation: json['livingSituation'] as String?,
      isAnimalAllowed: json['isAnimalAllowed'] as bool?,
      reasonId:json['reasonId'] as int?,
      user: userJson != null ? User.fromJson(userJson as Map<String, dynamic>) : null,
      animal: animalJson != null ? Animal.fromJson(animalJson as Map<String, dynamic>) : null,
      status: statusJson != null ? ApplicationStatus.fromJson(statusJson as Map<String, dynamic>) : null,
       reviewedBy: reviewedByJson != null ? User.fromJson(reviewedByJson as Map<String, dynamic>) : null, 
    );
  }

  AdoptionApplication({
      this.applicationID,
      required this.userID,
      required this.animalID,
      this.applicationDate,
      required this.statusID,
      this.notes,
      this.livingSituation,
      this.isAnimalAllowed,
      this.reasonId,
      this.user,
      this.animal,
      this.status,
      this.reviewedBy,
  });

  Map<String, dynamic> toJson() {
    return {
      if(applicationID != null) 'applicationID': applicationID,
      'userID': userID,
      'animalID': animalID,
      if(applicationDate != null) 'applicationDate': applicationDate!.toIso8601String(), 
      'statusID': statusID,
      'notes': notes,
      'livingSituation': livingSituation,
      'isAnimalAllowed': isAnimalAllowed,
      'reasonId': reasonId, 
    };
  }
}