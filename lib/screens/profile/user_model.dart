class UserModel {
  final String id; // Firestore document ID
  final String name;
  final String role;
  final String email;
  final String phone;
  final int age;
  final String gender;
  final String imageUrl;
  final String createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    required this.phone,
    required this.age,
    required this.gender,
    required this.imageUrl,
    required this.createdAt,
  });

  factory UserModel.fromMap(String id, Map<String, dynamic> data) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      role: data['role'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      age: data['age'] ?? 0,
      gender: data['gender'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: data['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role,
      'email': email,
      'phone': phone,
      'age': age,
      'gender': gender,
      'createdAt': createdAt,
    };
  }
}
