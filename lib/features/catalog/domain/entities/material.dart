import 'item.dart';

class Material extends Item {
  const Material({
    required super.code,
    required super.description,
    required super.groupCode,
    required super.groupDescription,
  });

  @override
  List<Object?> get props => [
        code,
        description,
        groupCode,
        groupDescription,
      ];
}
