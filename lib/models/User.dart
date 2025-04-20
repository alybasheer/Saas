class AppUser {
  final String id;
  final String name;
  final String email;
  final String role;  // "admin" or "parent"

  AppUser({required this.id, required this.name, required this.email, required this.role});

  factory AppUser.fromMap(Map<String, dynamic> data) {
    return AppUser(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      role: data['role'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
    };
  }
}
