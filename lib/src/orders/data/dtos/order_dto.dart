import '../../domain/entities/order.dart';

extension OrderDTO on Order {
  Map<String, dynamic> toMap() => {
        'number': number,
        'type': type,
        'arrivalDate': arrivalDate,
        'secretary': secretary,
        'project': project,
        'description': description,
        'sendDate': sendDate,
        'returnDate': returnDate,
        'situation': situation,
        'notes': notes,
      };

  static Order fromMap(Map<String, dynamic> map) => Order(
        number: map['number'],
        type: map['type'],
        arrivalDate: map['arrivalDate'] ?? '',
        secretary: map['secretary'] ?? '',
        project: map['project'] ?? '',
        description: map['description'] ?? '',
        sendDate: map['sendDate'] ?? '',
        returnDate: map['returnDate'] ?? '',
        situation: map['situation'] ?? '',
        notes: map['notes'] ?? '',
      );

  String get id => '${type}_$number';
}
