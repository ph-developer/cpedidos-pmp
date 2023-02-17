import '../../../shared/errors/failure.dart';
import '../../../shared/helpers/notify.dart';
import '../entities/order.dart';
import '../repositories/order_repo.dart';

abstract class IGetOrderByTypeAndNumber {
  Future<Order?> call(String type, String number);
}

class GetOrderByTypeAndNumber implements IGetOrderByTypeAndNumber {
  final IOrderRepo _orderRepo;

  GetOrderByTypeAndNumber(this._orderRepo);

  @override
  Future<Order?> call(String type, String number) async {
    try {
      if (number.isEmpty) {
        notifyError('O campo "número" deve ser preenchido.');
        return null;
      }

      if (type.isEmpty) {
        notifyError('O campo "tipo" deve ser preenchido.');
        return null;
      }

      final result = await _orderRepo.getByTypeAndNumber(type, number);

      return result;
    } on Failure catch (failure) {
      notifyError(failure.message);
      return null;
    }
  }
}
