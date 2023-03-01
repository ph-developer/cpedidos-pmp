import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final String groupCode;
  final String groupDescription;
  final String classCode;
  final String classDescription;
  final String code;
  final String description;

  const Service({
    required this.groupCode,
    required this.groupDescription,
    required this.classCode,
    required this.classDescription,
    required this.code,
    required this.description,
  });

  @override
  List<Object?> get props => [
        groupCode,
        groupDescription,
        classCode,
        classDescription,
        code,
        description,
      ];
}
