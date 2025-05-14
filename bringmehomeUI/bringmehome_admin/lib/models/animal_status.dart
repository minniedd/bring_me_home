class AnimalStatus{
  int statusID;
  String statusName;

  AnimalStatus({required this.statusID, required this.statusName});

  factory AnimalStatus.fromJson(Map<String, dynamic> json) {
    return AnimalStatus(
      statusID: json['statusID'],
      statusName: json['statusName'],
    );
  }
}