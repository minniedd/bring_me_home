class Canton {
  int cantonID;
  String cantonName;

  Canton({
    required this.cantonID, required this.cantonName
  });

  factory Canton.fromJson(Map<String, dynamic> json) {
    return Canton(
      cantonID: json['cantonID'] as int,
      cantonName: json['cantonName'] as String,
    );
  }
}