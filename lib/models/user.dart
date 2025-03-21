class User {
  final String id;
  final String username;
  final String email;
  final String? avatar;
  final String token;
  final int coins;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.avatar,
    required this.token,
    this.coins = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      avatar: json['avatar'],
      token: json['token'],
      coins: json['coins'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar': avatar,
      'token': token,
      'coins': coins,
    };
  }
}
