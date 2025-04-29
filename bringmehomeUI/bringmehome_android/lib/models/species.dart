class Species {
  int speciesID;
  String speciesName;

  Species({
    required this.speciesID,required this.speciesName
  });

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
      speciesID: json['speciesID'] as int,
      speciesName: json['speciesName'] as String,
    );
  }
}