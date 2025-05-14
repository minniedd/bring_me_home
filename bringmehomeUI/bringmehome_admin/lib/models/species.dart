class Species {
  final int speciesID;
  final String speciesName;
  final String? description;

  Species({
    required this.speciesID,
    required this.speciesName,
    this.description,
  });

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
      speciesID: json['speciesID'],
      speciesName: json['speciesName'],
      description: json['description'] != null ? json['description'] as String : null,
    );
  }
}