class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin' or 'user'
  final String? password; // Password for login
  final String? avatarUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.password,
    this.avatarUrl,
    this.createdAt,
    this.updatedAt,
  });

  bool get isAdmin => role.toLowerCase() == 'admin';
  bool get isUser => role.toLowerCase() == 'user';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      password: json['password'], // Password from API
      avatarUrl:
          json['avatar_url'] ??
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(json['name'] ?? 'User')}&background=1E88E5&color=fff&size=200',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['update_at'] != null
          ? DateTime.tryParse(json['update_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'password': password, // Include password in API calls
      'avatar_url': avatarUrl,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? password,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      password: password ?? this.password,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
