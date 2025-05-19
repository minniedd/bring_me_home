class User {
  final int? id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String? phoneNumber;
  final bool isActive;
  final DateTime? createdAt;
  final String? address;
  final String? city;
  final String? userImage;

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.username,
    this.phoneNumber,
    required this.isActive,
    this.createdAt,
    this.id,
    this.address,
    this.city,
    this.userImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      username: json['username'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      address: json['address'] as String?,
      city: json['city'] as String?,
      userImage: json['userImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'address': address,
      'city': city,
      'userImage': userImage,
    };
  }
}