class Breed {
  int breedID;
  String breedName;
  int? speciesID;

  Breed({
    required this.breedID,required this.breedName,this.speciesID,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      breedID: json['breedID'] as int,
      breedName: json['breedName'] as String,
      speciesID: json['speciesID'] != null ? json['speciesID'] as int : null,
    );
  }
}