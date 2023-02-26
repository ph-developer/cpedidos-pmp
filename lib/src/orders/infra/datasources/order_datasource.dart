import '../../domain/entities/order.dart';

abstract class IOrderDatasource {
  Future<Order> getOrderByTypeAndNumber(String type, String number);
  Future<List<Order>> getAllOrdersBySendDate(String sendDate);
  Future<Order> saveOrder(Order order);
  Future<bool> deleteOrder(String type, String number);
}
