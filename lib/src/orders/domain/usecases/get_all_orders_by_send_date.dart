import '../../../shared/errors/failure.dart';
import '../../../shared/helpers/notify.dart';
import '../entities/order.dart';
import '../repositories/order_repo.dart';

abstract class IGetAllOrdersBySendDate {
  Future<List<Order>> call(String sendDate);
}

class GetAllOrdersBySendDate implements IGetAllOrdersBySendDate {
  final IOrderRepo _orderRepo;

  GetAllOrdersBySendDate(this._orderRepo);

  @override
  Future<List<Order>> call(String sendDate) async {
    try {
      if (sendDate.isEmpty) {
        notifyError('O campo "data de envio" deve ser preenchido.');
        return [];
      }

      final result = await _orderRepo.getAllBySendDate(sendDate);

      return result;
    } on Failure catch (failure) {
      notifyError(failure.message);
      return [];
    }
  }
}
