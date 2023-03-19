import 'package:result_dart/result_dart.dart';

import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/order.dart';
import '../../domain/errors/failures.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_datasource.dart';

class OrderRepositoryImpl implements IOrderRepository {
  final IErrorHandler _errorHandler;
  final IOrderDatasource _orderDatasource;

  OrderRepositoryImpl(this._errorHandler, this._orderDatasource);

  @override
  AsyncResult<Order, OrdersFailure> getOrderByTypeAndNumber(
    String type,
    String number,
  ) async {
    try {
      final order = await _orderDatasource.getOrderByTypeAndNumber(
        type,
        number,
      );

      return Success(order);
    } on OrdersFailure catch (failure) {
      return Failure(failure);
    } catch (exception, stackTrace) {
      await _errorHandler.reportException(exception, stackTrace);
      return const Failure(UnknownError());
    }
  }

  @override
  AsyncResult<List<Order>, OrdersFailure> getAllOrdersBySendDate(
    String sendDate,
  ) async {
    try {
      final orders = await _orderDatasource.getAllOrdersBySendDate(sendDate);

      return Success(orders);
    } on OrdersFailure catch (failure) {
      return Failure(failure);
    } catch (exception, stackTrace) {
      await _errorHandler.reportException(exception, stackTrace);
      return const Failure(UnknownError());
    }
  }

  @override
  AsyncResult<List<Order>, OrdersFailure> getAllOrdersByArrivalDate(
    String arrivalDate,
  ) async {
    try {
      final orders = await _orderDatasource.getAllOrdersByArrivalDate(
        arrivalDate,
      );

      return Success(orders);
    } on OrdersFailure catch (failure) {
      return Failure(failure);
    } catch (exception, stackTrace) {
      await _errorHandler.reportException(exception, stackTrace);
      return const Failure(UnknownError());
    }
  }

  @override
  AsyncResult<Order, OrdersFailure> saveOrder(Order order) async {
    try {
      final savedOrder = await _orderDatasource.saveOrder(order);

      return Success(savedOrder);
    } on OrdersFailure catch (failure) {
      return Failure(failure);
    } catch (exception, stackTrace) {
      await _errorHandler.reportException(exception, stackTrace);
      return const Failure(UnknownError());
    }
  }

  @override
  AsyncResult<Unit, OrdersFailure> deleteOrder(Order order) async {
    try {
      await _orderDatasource.deleteOrder(order);

      return const Success(unit);
    } on OrdersFailure catch (failure) {
      return Failure(failure);
    } catch (exception, stackTrace) {
      await _errorHandler.reportException(exception, stackTrace);
      return const Failure(UnknownError());
    }
  }
}
