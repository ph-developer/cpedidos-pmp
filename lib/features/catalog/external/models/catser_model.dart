import 'package:equatable/equatable.dart';

class CatserModel extends Equatable {
  final String extractionDate;
  final Map<String, String> groups;
  final Map<String, List<String>> items;

  const CatserModel({
    required this.extractionDate,
    required this.groups,
    required this.items,
  });

  factory CatserModel.fromMap(Map<String, dynamic> map) {
    return CatserModel(
      extractionDate: map['extraction_date'],
      groups: Map<String, String>.from(map['groups']),
      items: Map<String, dynamic>.from(map['items'])
          .map((key, value) => MapEntry(key, List<String>.from(value))),
    );
  }

  @override
  List<Object?> get props => [extractionDate, groups, items];
}
