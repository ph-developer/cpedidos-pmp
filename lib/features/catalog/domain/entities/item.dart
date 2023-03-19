import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String code;
  final String description;
  final String groupCode;
  final String groupDescription;

  const Item({
    required this.code,
    required this.description,
    required this.groupCode,
    required this.groupDescription,
  });

  @override
  List<Object?> get props => [
        code,
        description,
        groupCode,
        groupDescription,
      ];
}
