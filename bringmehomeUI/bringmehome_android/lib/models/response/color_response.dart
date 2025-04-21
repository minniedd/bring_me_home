class ColorResponse {
  int? colorID;
  String? colorName;

  ColorResponse({this.colorID, this.colorName});

  factory ColorResponse.fromJson(Map<String, dynamic> json) {
    return ColorResponse(
      colorID: json['colorID'],
      colorName: json['colorName'],
    );
  }
}