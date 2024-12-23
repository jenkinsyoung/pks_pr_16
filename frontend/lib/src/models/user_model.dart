class UserFromDB{
  String userId;
  String username;
  String email;
  String password;
  String image;
  String phone;
  final String role;

  UserFromDB({
    required this.userId,
    required this.username,
    required this.email,
    required this.password,
    required this.image,
    required this.phone,
    required this.role
  });
  factory UserFromDB.fromJson(Map<String, dynamic> json) {
    return UserFromDB(
      userId: json['user_id'] ?? '',
      username: json['username'] is Map<String, dynamic> ? json['username']['String'] ?? '' : json['username'] ?? '',
      image: json['image'] is Map<String, dynamic> ? json['image']['String'] ?? '' : json['image'] ?? '',
      email: json['email'] ?? '',
      password: json['password_hash'] is Map<String, dynamic> ? json['password_hash']['String'] ?? '' : json['password_hash'] ?? '',
      phone: json['phone'] is Map<String, dynamic> ? json['phone']['String'] ?? '' : json['phone'] ?? '',
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      "username": {
        "String": username,
        "Valid": true
      },
      "image": {
        "String": image,
        "Valid": true
      },
      'email': email,
      'password_hash': {
        "String": password,
        "Valid": true
      },
      "phone": {
        "String": phone,
        "Valid": true
      },
      'role': role
    };
  }
}