class Reason {
  final int reasonID;
  final String reasonName;

  Reason({required this.reasonID, required this.reasonName});

  factory Reason.fromJson(Map<String, dynamic> json) {
    return Reason(
      reasonID: json['reasonID'] as int,
      reasonName: json['reasonName'] as String? ?? 'Unknown Reason', 
    );
  }
}