import '../entities/order.dart';

extension OrderDTO on Order {
  Order copyWith({
    String? number,
    String? type,
    String? arrivalDate,
    String? secretary,
    String? project,
    String? description,
    String? sendDate,
    String? returnDate,
    String? situation,
    String? notes,
  }) =>
      Order(
        number: number ?? this.number,
        type: type ?? this.type,
        arrivalDate: arrivalDate ?? this.arrivalDate,
        secretary: secretary ?? this.secretary,
        project: project ?? this.project,
        description: description ?? this.description,
        sendDate: sendDate ?? this.sendDate,
        returnDate: returnDate ?? this.returnDate,
        situation: situation ?? this.situation,
        notes: notes ?? this.notes,
      );

  static empty() => const Order(
        number: '',
        type: 'SE',
        arrivalDate: '',
        secretary: '',
        project: '',
        description: '',
        sendDate: '',
        returnDate: '',
        situation: '',
        notes: '',
      );
}
