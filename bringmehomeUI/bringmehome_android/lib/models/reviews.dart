import 'package:learning_app/models/user.dart';

class Review {
  int? reviewID;
  int? userID;
  int? shelterID;
  String? shelterName;
  int rating;
  String comment;
  DateTime? createdAt;
  DateTime? updatedAt;
  final User? user; 

  Review({
    this.reviewID,
    this.userID,
    this.shelterID,
    this.shelterName,
    required this.rating,
    required this.comment,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewID: json['reviewID'],
      userID: json['userID'],
      shelterID: json['shelterID'],
      shelterName: json['shelterName'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'rating': rating,
      'comment': comment,
    };

    if (reviewID != null) data['reviewID'] = reviewID;
    if (userID != null) data['userID'] = userID;
    if (shelterID != null) data['shelterID'] = shelterID;

    return data;
  }
}