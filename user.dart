class User {
  final int? id;
  final String fullName;
  final String email;
  final String password;
  final String role;
  String? address; // Allow address to be mutable
  final String? phone;

  User({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    this.address,
    this.phone,
  });

  // Convert user to map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'password': password,
      'role': role, // Store the role in the database
      'address': address,
      'phone': phone,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'password': password,
      'role': role,
      'address': address,
      'phone': phone,
    };
  }

  // Convert map to user object
  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      fullName: map['full_name'],
      email: map['email'],
      password: map['password'],
      role: map['role'],
      address: map['address'],
      phone: map['phone'],
    );
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      address: json['address'],
      phone: json['phone'],
    );
  }
}
