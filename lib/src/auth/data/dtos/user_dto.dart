import '../../domain/entities/user.dart';

extension UserDTO on User {
  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      name: map['name'],
      isAdmin: map['isAdmin'] ?? false,
    );
  }
}
