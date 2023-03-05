import 'item.dart';

class Service extends Item {
  final String groupCode;
  final String groupDescription;
  final String classCode;
  final String classDescription;

  const Service({
    required this.groupCode,
    required this.groupDescription,
    required this.classCode,
    required this.classDescription,
    required super.code,
    required super.description,
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
