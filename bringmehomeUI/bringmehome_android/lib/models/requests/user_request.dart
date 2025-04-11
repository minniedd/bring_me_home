class UserRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String password;
  final String phoneNumber;
  final bool isActive;

  UserRequest(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.username,
      required this.password,
      required this.phoneNumber,
      this.isActive = true
  });

  Map<String,dynamic>toJson()=> {
    'firstName': firstName,
    'lastName': lastName,
    'email': email,
    'username': username,
    'password': password,
    'phoneNumber': phoneNumber,
    'isActive': isActive,
  };

}
