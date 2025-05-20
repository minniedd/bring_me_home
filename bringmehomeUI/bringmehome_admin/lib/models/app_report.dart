class AppReport {
  int totalAnimals;
  int totalAdoptions;
  int totalActiveAdoptions;
  Map<String, int> totalAnimalsBySpecies;

  AppReport({
    required this.totalAnimals,
    required this.totalAdoptions,
    required this.totalActiveAdoptions,
    required this.totalAnimalsBySpecies,
  });

  factory AppReport.fromJson(Map<String, dynamic> json) {
    return AppReport(
      totalAnimals: json['totalAnimals'] ?? 0,
      totalAdoptions: json['totalAdoptions'] ?? 0,
      totalActiveAdoptions: json['totalActiveAdoptions'] ?? 0,
      totalAnimalsBySpecies: Map<String, int>.from(json['totalAnimalsBySpecies'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalAnimals': totalAnimals,
      'totalAdoptions': totalAdoptions,
      'totalActiveAdoptions': totalActiveAdoptions,
      'totalAnimalsBySpecies': totalAnimalsBySpecies,
    };
  }
}