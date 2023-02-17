import '../../../shared/errors/failure.dart';
import '../../../shared/helpers/notify.dart';
import '../entities/order.dart';
import '../repositories/order_repo.dart';

abstract class ISaveOrder {
  Future<Order?> call(Order order);
}

class SaveOrder implements ISaveOrder {
  final IOrderRepo _orderRepo;

  SaveOrder(this._orderRepo);

  @override
  Future<Order?> call(Order order) async {
    try {
      if (order.number.isEmpty) {
        notifyError('O campo "número" deve ser preenchido.');
        return null;
      }

      if (order.type.isEmpty) {
        notifyError('O campo "tipo" deve ser preenchido.');
        return null;
      }

      final result = await _orderRepo.save(order);

      notifySuccess('Pedido salvo com sucesso.');

      return result;
    } on Failure catch (failure) {
      notifyError(failure.message);
      return null;
    }
  }
}
