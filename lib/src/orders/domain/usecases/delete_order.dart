import '../../../shared/errors/failure.dart';
import '../../../shared/helpers/notify.dart';
import '../entities/order.dart';
import '../repositories/order_repo.dart';

abstract class IDeleteOrder {
  Future<bool> call(Order order);
}

class DeleteOrder implements IDeleteOrder {
  final IOrderRepo _orderRepo;

  DeleteOrder(this._orderRepo);

  @override
  Future<bool> call(Order order) async {
    try {
      if (order.number.isEmpty) {
        notifyError('O campo "número" deve ser preenchido.');
        return false;
      }

      if (order.type.isEmpty) {
        notifyError('O campo "tipo" deve ser preenchido.');
        return false;
      }

      final result = await _orderRepo.delete(order);

      if (result) {
        notifySuccess('Pedido excluido com sucesso.');
      }

      return result;
    } on Failure catch (failure) {
      notifyError(failure.message);
      return false;
    }
  }
}
