import '../entities/order.dart';

abstract class IOrderRepo {
  Future<Order?> getByTypeAndNumber(String type, String number);
  Future<List<Order>> getAllBySendDate(String sendDate);
  Future<Order?> save(Order order);
  Future<bool> delete(Order order);
}
