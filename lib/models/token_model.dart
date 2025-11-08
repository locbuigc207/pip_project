class TokenModel {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;
  final DateTime issuedAt;

  TokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
    required this.issuedAt,
  });

  bool get isExpired {
    return DateTime.now().isAfter(expiresAt);
  }

  bool get needsRefresh {
    final threshold = expiresAt.subtract(const Duration(minutes: 5));
    return DateTime.now().isAfter(threshold);
  }

  Duration get remainingTime {
    return expiresAt.difference(DateTime.now());
  }

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
      accessToken: json['access_token'] ?? json['token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : DateTime.now().add(Duration(
        seconds: json['expires_in'] ?? 3600,
      )),
      issuedAt: json['issued_at'] != null
          ? DateTime.parse(json['issued_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
      'issued_at': issuedAt.toIso8601String(),
    };
  }

  TokenModel copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
    DateTime? issuedAt,
  }) {
    return TokenModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
      issuedAt: issuedAt ?? this.issuedAt,
    );
  }

  @override
  String toString() {
    return 'TokenModel(accessToken: ${accessToken.substring(0, 10)}..., '
        'expiresAt: $expiresAt, needsRefresh: $needsRefresh, '
        'isExpired: $isExpired)';
  }
}