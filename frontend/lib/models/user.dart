class User {
  final String name;
  final String email;
  final String password;
  final String role;

  User(
      {required this.name,
      required this.role,
      required this.email,
      required this.password});

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      };
}
