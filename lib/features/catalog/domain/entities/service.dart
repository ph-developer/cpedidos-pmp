import 'item.dart';

class Service extends Item {
  const Service({
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
