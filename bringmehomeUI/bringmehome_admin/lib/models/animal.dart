class Animal {
  int? animalID;
  String? name;
  String? description;
  int? breedID;
  String? breedName;
  int? age;
  String? gender;
  double? weight;
  DateTime? dateArrived;
  int? statusID;
  String? healthStatus;
  int? shelterID;
  String? shelterName;
  int? colorID;
  String? colorName;
  int? tempermentID;
  String? tempermentName;
  bool isFavorite;

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
    this.colorID,
    this.colorName,
    this.tempermentID,
    this.tempermentName,
    this.breedName,
    this.shelterName,
    this.isFavorite = false,
  });

  factory Animal.fromJson(Map<String, dynamic> json) {
    return Animal(
      animalID: json['animalID'] as int?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      breedID: json['breedID'] as int?,
      breedName: json['breedName'] as String?,
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
      shelterName: json['shelterName'] as String?,
      colorID: json['colorID'] as int?,
      colorName: json['colorName'] as String?,
      tempermentID: json['tempermentID'] as int?,
      tempermentName: json['tempermentName'] as String?,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }
}