import 'item.dart';

class Material extends Item {
  final String groupCode;
  final String groupDescription;
  final String classCode;
  final String classDescription;
  final String standardCode;
  final String standardDescription;

  const Material({
    required this.groupCode,
    required this.groupDescription,
    required this.classCode,
    required this.classDescription,
    required this.standardCode,
    required this.standardDescription,
    required super.code,
    required super.description,
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
