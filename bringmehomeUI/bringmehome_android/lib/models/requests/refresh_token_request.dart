class RefreshTokenRequest {
  final int userId;
  final String refreshToken;

  RefreshTokenRequest({required this.userId, required this.refreshToken});

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'refreshToken': refreshToken,
  };
}