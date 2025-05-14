class Temperment {
  int? temperamentID;
  String? name;

  Temperment({this.temperamentID, this.name});

  factory Temperment.fromJson(Map<String, dynamic> json) {
    return Temperment(
      temperamentID: json['temperamentID'],
      name: json['name'],
    );
  }
}