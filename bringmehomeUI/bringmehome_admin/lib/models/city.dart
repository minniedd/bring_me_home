class City {
  final int? cityID;
  final String cityName;

  City({this.cityID, required this.cityName});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      cityID: json['cityID'] as int?,
      cityName: json['cityName'] as String,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'cityID': cityID,
      'cityName': cityName,
    };
  }
}
