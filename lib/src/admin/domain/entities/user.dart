import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String email;
  final String name;
  final String? password;
  final bool isAdmin;

  const User({
    this.id,
    required this.email,
    required this.name,
    this.password,
    this.isAdmin = false,
  });

  @override
  List<Object?> get props => [id, email, name, password, isAdmin];
}
