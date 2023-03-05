import 'package:equatable/equatable.dart';

class Item extends Equatable {
  final String code;
  final String description;

  const Item({
    required this.code,
    required this.description,
  });

  @override
  List<Object?> get props => [
        code,
        description,
      ];
}
