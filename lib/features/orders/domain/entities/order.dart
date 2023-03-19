import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final String number;
  final String type;
  final String arrivalDate;
  final String secretary;
  final String project;
  final String description;
  final String sendDate;
  final String returnDate;
  final String situation;
  final String notes;
  final bool isArchived;

  const Order({
    required this.number,
    required this.type,
    required this.arrivalDate,
    required this.secretary,
    required this.project,
    required this.description,
    this.sendDate = '',
    this.returnDate = '',
    this.situation = '',
    this.notes = '',
    this.isArchived = false,
  });

  @override
  List<Object?> get props => [
        number,
        type,
        arrivalDate,
        secretary,
        project,
        description,
        sendDate,
        returnDate,
        situation,
        notes,
        isArchived,
      ];
}
