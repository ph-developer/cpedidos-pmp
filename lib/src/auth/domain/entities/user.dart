import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final bool isAdmin;

  const User({
    required this.id,
    required this.email,
    required this.name,
    this.isAdmin = false,
  });

  @override
  List<Object?> get props => [id, email, name, isAdmin];
}
