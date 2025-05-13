class Color {
  int? colorID;
  String? colorName;

  Color({this.colorID, this.colorName});

  factory Color.fromJson(Map<String, dynamic> json) {
    return Color(
      colorID: json['colorID'],
      colorName: json['colorName'],
    );
  }
}