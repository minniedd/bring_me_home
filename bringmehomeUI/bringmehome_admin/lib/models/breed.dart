class Breed {
  int breedID;
  String breedName;

  Breed({
    required this.breedID,required this.breedName
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      breedID: json['breedID'] as int,
      breedName: json['breedName'] as String,
    );
  }
}