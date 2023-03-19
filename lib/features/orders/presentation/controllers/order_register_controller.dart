// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

import '../../../../core/helpers/debounce.dart';
import '../../domain/entities/order.dart';
import '../../domain/errors/failures.dart';
import '../../domain/usecases/delete_order.dart';
import '../../domain/usecases/get_order_by_type_and_number.dart';
import '../../domain/usecases/save_order.dart';

part 'order_register_controller.g.dart';

enum SuccessfulAction { save, delete }

class OrderRegisterController = _OrderRegisterControllerBase
    with _$OrderRegisterController;

abstract class _OrderRegisterControllerBase with Store {
  final ISaveOrder _saveOrder;
  final IDeleteOrder _deleteOrder;
  final IGetOrderByTypeAndNumber _getOrderByTypeAndNumber;

  _OrderRegisterControllerBase(
    this._saveOrder,
    this._deleteOrder,
    this._getOrderByTypeAndNumber,
  );

  @observable
  bool isSearching = false;

  @observable
  bool isLoading = false;

  @observable
  bool isLoaded = false;

  @observable
  Order? loadedOrder;

  @observable
  Map<String, String>? currentQuery;

  @observable
  OrdersFailure? failure;

  @observable
  SuccessfulAction? success;

  @action
  Future<void> clearSearch() async {
    isLoading = true;
    loadedOrder = null;
    currentQuery = null;
    isLoaded = false;
    isLoading = false;
  }

  @action
  Future<void> searchOrder(Map<String, String> payload) async {
    isSearching = true;
    loadedOrder = null;
    isLoaded = false;
    failure = null;

    final number = payload['number'] ?? '';
    final type = payload['type'] ?? '';
    final query = {'number': number, 'type': type};
    currentQuery = query;

    _debouncedSearchOrder ??= debounce3(_searchOrder, 500);
    _debouncedSearchOrder?.call(type, number, query);
  }

  void Function(String, String, Map<String, String>)? _debouncedSearchOrder;

  @action
  Future<void> _searchOrder(
    String type,
    String number,
    Map<String, String> query,
  ) async {
    if (type.isNotEmpty && number.isNotEmpty) {
      final result = await _getOrderByTypeAndNumber(type, number);
      if (query != currentQuery) return;

      result.fold(
        (order) {
          loadedOrder = order;
          isLoaded = true;
        },
        (failure) {
          if (failure is OrderNotFound) {
            loadedOrder = null;
            isLoaded = true;
          } else {
            loadedOrder = null;
            isLoaded = false;
            this.failure = failure;
          }
        },
      );
    }

    isSearching = false;
  }

  @action
  Future<void> saveOrder(Map<String, String> payload) async {
    isLoading = true;
    success = null;
    failure = null;

    final order = _mapPayloadToOrder(payload);

    final result = await _saveOrder(order);

    result.fold(
      (order) {
        loadedOrder = order;
        isLoaded = true;
        success = SuccessfulAction.save;
      },
      (failure) => this.failure = failure,
    );

    isLoading = false;
  }

  @action
  Future<void> deleteOrder(Map<String, String> payload) async {
    isLoading = true;
    success = null;
    failure = null;

    final order = _mapPayloadToOrder(payload);

    final result = await _deleteOrder(order);

    result.fold(
      (success) {
        loadedOrder = null;
        this.success = SuccessfulAction.delete;
      },
      (failure) => this.failure = failure,
    );

    isLoading = false;
  }

  Order _mapPayloadToOrder(Map<String, String> payload) {
    return Order(
      number: payload['number'] ?? '',
      type: payload['type'] ?? '',
      arrivalDate: payload['arrivalDate'] ?? '',
      secretary: payload['secretary'] ?? '',
      project: payload['project'] ?? '',
      description: payload['description'] ?? '',
      sendDate: payload['sendDate'] ?? '',
      returnDate: payload['returnDate'] ?? '',
      situation: payload['situation'] ?? '',
      notes: payload['notes'] ?? '',
    );
  }
}
