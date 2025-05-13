class AnimalTemperament{
  int? temperamentID;
  String? name;

  AnimalTemperament({this.temperamentID, this.name});

  factory AnimalTemperament.fromJson(Map<String, dynamic> json) {
    return AnimalTemperament(
      temperamentID: json['temperamentID'],
      name: json['name'],
    );
  }
}