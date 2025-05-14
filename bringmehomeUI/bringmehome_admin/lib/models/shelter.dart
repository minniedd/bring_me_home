class Shelter {
  final int shelterID;
  final String name;
  final String? address;
  final int cityID;
  final String? zipCode;
  final String? phone;
  final String? email;
  final int capacity;
  final int currentOccupancy;
  final String? operatingHours;

  Shelter({
    required this.shelterID,
    required this.name,
    this.address,
    required this.cityID,
    this.zipCode,
    this.phone,
    this.email,
    required this.capacity,
    required this.currentOccupancy,
    this.operatingHours,
  });

  factory Shelter.fromJson(Map<String, dynamic> json) {
    return Shelter(
      shelterID: json['shelterID'],
      name: json['name'],
      address: json['address'],
      cityID: json['cityID'],
      zipCode: json['zipCode'],
      phone: json['phone'],
      email: json['email'],
      capacity: json['capacity'],
      currentOccupancy: json['currentOccupancy'],
      operatingHours: json['operatingHours'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shelterID': shelterID,
      'name': name,
      'address': address,
      'cityID': cityID,
      'zipCode': zipCode,
      'phone': phone,
      'email': email,
      'capacity': capacity,
      'currentOccupancy': currentOccupancy,
      'operatingHours': operatingHours,
    };
  }
}