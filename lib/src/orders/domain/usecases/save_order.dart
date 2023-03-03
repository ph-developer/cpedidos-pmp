import 'package:intl/intl.dart';
import 'package:result_dart/result_dart.dart';

import '../entities/order.dart';
import '../errors/failures.dart';
import '../repositories/order_repository.dart';

abstract class ISaveOrder {
  AsyncResult<Order, OrdersFailure> call(Order order);
}

class SaveOrder implements ISaveOrder {
  final IOrderRepository _orderRepository;

  SaveOrder(this._orderRepository);

  @override
  AsyncResult<Order, OrdersFailure> call(Order order) async {
    if (order.number.isEmpty) {
      return const Failure(
        InvalidInput('O campo "número" deve ser preenchido.'),
      );
    }

    if (order.type.isEmpty) {
      return const Failure(
        InvalidInput('O campo "tipo" deve ser preenchido.'),
      );
    }

    if (order.arrivalDate.isEmpty) {
      return const Failure(
        InvalidInput('O campo "data de chegada" deve ser preenchido.'),
      );
    }

    if (order.secretary.isEmpty) {
      return const Failure(
        InvalidInput('O campo "secretaria" deve ser preenchido.'),
      );
    }

    if (order.project.isEmpty) {
      return const Failure(
        InvalidInput('O campo "projeto" deve ser preenchido.'),
      );
    }

    if (order.description.isEmpty) {
      return const Failure(
        InvalidInput('O campo "descrição" deve ser preenchido.'),
      );
    }

    if (order.sendDate.isEmpty && order.returnDate.isNotEmpty) {
      return const Failure(
        InvalidInput(
          'O campo "data de retorno do financeiro" não deve ser preenchido '
          'quando o campo "data de envio ao financeiro" não estiver '
          'preenchido.',
        ),
      );
    }

    final now = DateTime.now();
    final currentDate = DateTime(now.year, now.month, now.day);
    final dateFormat = DateFormat('dd/MM/yyyy');

    late DateTime arrivalDate;
    try {
      arrivalDate = dateFormat.parseStrict(order.arrivalDate);
    } catch (e) {
      return const Failure(
        InvalidInput('O campo "data de chegada" não possui uma data válida.'),
      );
    }

    DateTime? sendDate;
    if (order.sendDate.isNotEmpty) {
      try {
        sendDate = dateFormat.parseStrict(order.sendDate);
      } catch (e) {
        return const Failure(
          InvalidInput(
            'O campo "data de envio ao financeiro" não possui uma data válida.',
          ),
        );
      }
    }

    DateTime? returnDate;
    if (order.returnDate.isNotEmpty) {
      try {
        returnDate = dateFormat.parseStrict(order.returnDate);
      } catch (e) {
        return const Failure(
          InvalidInput(
            'O campo "data de retorno do financeiro" não possui uma data '
            'válida.',
          ),
        );
      }
    }

    if (arrivalDate.compareTo(currentDate) == 1) {
      return const Failure(
        InvalidInput(
          'O campo "data de chegada" deve possuir uma data igual ou inferior '
          'ao dia atual.',
        ),
      );
    }

    if (sendDate != null && sendDate.compareTo(currentDate) == 1) {
      return const Failure(
        InvalidInput(
          'O campo "data de envio ao financeiro" deve possuir uma data igual '
          'ou inferior ao dia atual.',
        ),
      );
    }

    if (returnDate != null && returnDate.compareTo(currentDate) == 1) {
      return const Failure(
        InvalidInput(
          'O campo "data de retorno do financeiro" deve possuir uma data igual '
          'ou inferior ao dia atual.',
        ),
      );
    }

    if (sendDate != null && sendDate.compareTo(arrivalDate) == -1) {
      return const Failure(
        InvalidInput(
          'O campo "data de chegada" deve possuir uma data igual ou inferior à '
          '"data de envio ao financeiro".',
        ),
      );
    }

    if (sendDate != null &&
        returnDate != null &&
        returnDate.compareTo(sendDate) == -1) {
      return const Failure(
        InvalidInput(
          'O campo "data de envio ao financeiro" deve possuir uma data igual '
          'ou inferior à "data de retorno do financeiro".',
        ),
      );
    }

    final tenYearsAgoDate = currentDate.subtract(const Duration(days: 3650));

    if (arrivalDate.compareTo(tenYearsAgoDate) == -1) {
      return const Failure(
        InvalidInput(
          'O campo "data de chegada" não pode possuir uma data inferior à 10 '
          'anos do dia atual.',
        ),
      );
    }

    return _orderRepository.saveOrder(order);
  }
}
