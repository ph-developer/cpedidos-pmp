import 'package:equatable/equatable.dart';

class LoggedUser extends Equatable {
  final String id;
  final String email;

  const LoggedUser({
    required this.id,
    required this.email,
  });

  @override
  List<Object?> get props => [id, email];
}
