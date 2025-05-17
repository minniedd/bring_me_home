class UserStaff {
  int? userID;
  String firstName;
  String lastName;
  String email;
  String username;
  String phoneNumber;
  String address;
  int cityID;
  bool isActive;
  String password;
  
  int? staffID;
  String position;
  String department;
  int shelterID;
  DateTime hireDate;
  String status;
  int accessLevel;

  UserStaff({
    this.userID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.address,
    required this.cityID,
    this.isActive = true,
    required this.password,
    this.staffID,
    required this.position,
    required this.department,
    required this.shelterID,
    required this.hireDate,
    required this.status,
    required this.accessLevel,
  });

  Map<String, dynamic> userToJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'address': address,
      'cityID': cityID,
      'isActive': isActive,
      'password': password,
    };
  }

  Map<String, dynamic> staffToJson() {
    return {
      'userID': userID,
      'position': position,
      'department': department,
      'shelterID': shelterID,
      'hireDate': hireDate.toIso8601String(),
      'status': status,
      'accessLevel': accessLevel,
    };
  }

  factory UserStaff.fromJson(Map<String, dynamic> json) {
    return UserStaff(
      userID: json['userID'] ?? json['userId'] ?? json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      cityID: json['cityID'] ?? 0,
      isActive: json['isActive'] ?? true,
      password: '',
      staffID: json['staffID'] ?? json['staffId'],
      position: json['position'] ?? '',
      department: json['department'] ?? '',
      shelterID: json['shelterID'] ?? json['shelterId'] ?? 0,
      hireDate: json['hireDate'] != null 
          ? DateTime.parse(json['hireDate']) 
          : DateTime.now(),
      status: json['status'] ?? '',
      accessLevel: json['accessLevel'] ?? 0,
    );
  }

  static UserStaff fromResponses(Map<String, dynamic> userResponse, Map<String, dynamic> staffResponse) {
    return UserStaff(
      userID: userResponse['id'] ?? userResponse['userId'] ?? userResponse['userID'],
      firstName: userResponse['firstName'] ?? '',
      lastName: userResponse['lastName'] ?? '',
      email: userResponse['email'] ?? '',
      username: userResponse['username'] ?? '',
      phoneNumber: userResponse['phoneNumber'] ?? '',
      address: userResponse['address'] ?? '',
      cityID: userResponse['cityID'] ?? 0,
      isActive: userResponse['isActive'] ?? true,
      password: '',
      staffID: staffResponse['staffID'] ?? staffResponse['id'],
      position: staffResponse['position'] ?? '',
      department: staffResponse['department'] ?? '',
      shelterID: staffResponse['shelterID'] ?? staffResponse['shelterId'] ?? 0,
      hireDate: staffResponse['hireDate'] != null 
          ? DateTime.parse(staffResponse['hireDate']) 
          : DateTime.now(),
      status: staffResponse['status'] ?? '',
      accessLevel: staffResponse['accessLevel'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'UserStaff: $firstName $lastName (ID: $userID), Staff ID: $staffID, Position: $position';
  }
}