// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/reactivity/obs_paginated_list.dart';
import '../../domain/entities/order.dart';
import '../../domain/errors/failures.dart';
import '../../domain/usecases/get_all_orders_by_arrival_date.dart';
import '../../domain/usecases/get_all_orders_by_send_date.dart';

part 'orders_search_controller.g.dart';

class OrdersSearchController = _OrdersSearchControllerBase
    with _$OrdersSearchController;

abstract class _OrdersSearchControllerBase with Store {
  final IGetAllOrdersBySendDate _getAllOrdersBySendDate;
  final IGetAllOrdersByArrivalDate _getAllOrdersByArrivalDate;

  _OrdersSearchControllerBase(
    this._getAllOrdersBySendDate,
    this._getAllOrdersByArrivalDate,
  );

  @observable
  bool isLoading = false;

  @observable
  bool isLoaded = false;

  @observable
  ObservablePaginatedList<Order> loadedOrders = ObservablePaginatedList.of([]);

  @observable
  OrdersFailure? failure;

  @action
  Future<void> clearSearch() async {
    isLoading = true;
    loadedOrders.clear();
    isLoaded = false;
    isLoading = false;
  }

  @action
  Future<void> searchOrders(Map<String, String> payload) async {
    isLoading = true;
    failure = null;
    loadedOrders.clear();

    final searchType = payload['searchType'] ?? '';
    final query = payload['query'] ?? '';

    AsyncResult<List<Order>, OrdersFailure>? usecase;

    if (searchType == 'sendDate') {
      usecase = _getAllOrdersBySendDate(query);
    } else if (searchType == 'arrivalDate') {
      usecase = _getAllOrdersByArrivalDate(query);
    }

    if (usecase != null) {
      final result = await usecase;
      result.fold(
        loadedOrders.addAll,
        (failure) => this.failure = failure,
      );
      isLoaded = true;
    }

    isLoading = false;
  }
}
