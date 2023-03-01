import 'package:equatable/equatable.dart';

class Material extends Equatable {
  final String groupCode;
  final String groupDescription;
  final String classCode;
  final String classDescription;
  final String standardCode;
  final String standardDescription;
  final String code;
  final String description;

  const Material({
    required this.groupCode,
    required this.groupDescription,
    required this.classCode,
    required this.classDescription,
    required this.standardCode,
    required this.standardDescription,
    required this.code,
    required this.description,
  });

  @override
  List<Object?> get props => [
        groupCode,
        groupDescription,
        classCode,
        classDescription,
        standardCode,
        standardDescription,
        code,
        description,
      ];
}
