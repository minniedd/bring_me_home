class ApplicationStatus {
  final int statusID;
  final String statusName;

  ApplicationStatus({required this.statusID, required this.statusName});

  factory ApplicationStatus.fromJson(Map<String, dynamic> json) {
    return ApplicationStatus(
      statusID: json['statusID'] as int,
      statusName: json['statusName'] as String? ?? 'Unknown Status',
    );
  }
}