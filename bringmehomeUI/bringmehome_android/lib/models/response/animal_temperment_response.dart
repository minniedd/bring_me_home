class AnimalTemperamentResponse {
  int? temperamentID;
  String? name;

  AnimalTemperamentResponse({this.temperamentID, this.name});

  factory AnimalTemperamentResponse.fromJson(Map<String, dynamic> json) {
    return AnimalTemperamentResponse(
      temperamentID: json['temperamentID'],
      name: json['name'],
    );
  }
}