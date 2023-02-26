import '../../domain/entities/logged_user.dart';

class LoggedUserModel extends LoggedUser {
  const LoggedUserModel({required super.id, required super.email});

  factory LoggedUserModel.fromMap(Map<String, dynamic> map) {
    return LoggedUserModel(
      id: map['id'],
      email: map['email'],
    );
  }
}
