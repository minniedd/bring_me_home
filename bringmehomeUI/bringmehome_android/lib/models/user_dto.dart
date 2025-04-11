class UserDto {
  final String username;
  final String password;

  UserDto({required this.username, required this.password});

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}
