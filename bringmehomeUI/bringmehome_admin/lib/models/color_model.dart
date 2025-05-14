class ColorModel {
  int? colorID;
  String? colorName;

  ColorModel({this.colorID, this.colorName});

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      colorID: json['colorID'],
      colorName: json['colorName'],
    );
  }
}