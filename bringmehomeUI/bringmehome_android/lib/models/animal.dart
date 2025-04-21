import 'package:learning_app/models/response/animal_temperment_response.dart';
import 'package:learning_app/models/response/color_response.dart';

class Animal {
  int? animalID;
  String? name;
  String? description;
  int? breedID;
  int? age;
  String? gender;
  double? weight;
  DateTime? dateArrived;
  int? statusID;
  String? healthStatus;
  int? shelterID;
  List<ColorResponse>? colors;
  List<AnimalTemperamentResponse>? temperaments;

  Animal({
    this.animalID,
    this.name,
    this.description,
    this.breedID,
    this.age,
    this.gender,
    this.weight,
    this.dateArrived,
    this.statusID,
    this.healthStatus,
    this.shelterID,
    this.colors,
    this.temperaments,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    try {
      return Animal(
        animalID: json['animalID'] as int?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        breedID: json['breedID'] as int?,
        age: json['age'] != null ? int.tryParse(json['age'].toString()) : null,
        gender: json['gender'] as String?,
        weight: json['weight'] != null
            ? double.tryParse(json['weight'].toString())
            : null,
        dateArrived: json['dateArrived'] != null
            ? DateTime.tryParse(json['dateArrived'].toString())
            : null,
        statusID: json['statusID'] as int?,
        healthStatus: json['healthStatus'] as String?,
        shelterID: json['shelterID'] as int?,
        colors: (json['colors'] as List<dynamic>?)
                ?.map((i) => ColorResponse.fromJson(i))
                .toList() ??
            [],
        temperaments: (json['temperaments'] as List<dynamic>?)
                ?.map((i) => AnimalTemperamentResponse.fromJson(i))
                .toList() ??
            [],
      );
    } catch (e) {
      print('Error parsing Animal: $e');
      print('Problematic JSON: $json');
      rethrow;
    }
  }
}
