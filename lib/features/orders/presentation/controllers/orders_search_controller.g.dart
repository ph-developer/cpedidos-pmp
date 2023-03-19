// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_search_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OrdersSearchController on _OrdersSearchControllerBase, Store {
  late final _$isLoadingAtom =
      Atom(name: '_OrdersSearchControllerBase.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$isLoadedAtom =
      Atom(name: '_OrdersSearchControllerBase.isLoaded', context: context);

  @override
  bool get isLoaded {
    _$isLoadedAtom.reportRead();
    return super.isLoaded;
  }

  @override
  set isLoaded(bool value) {
    _$isLoadedAtom.reportWrite(value, super.isLoaded, () {
      super.isLoaded = value;
    });
  }

  late final _$loadedOrdersAtom =
      Atom(name: '_OrdersSearchControllerBase.loadedOrders', context: context);

  @override
  ObservablePaginatedList<Order> get loadedOrders {
    _$loadedOrdersAtom.reportRead();
    return super.loadedOrders;
  }

  @override
  set loadedOrders(ObservablePaginatedList<Order> value) {
    _$loadedOrdersAtom.reportWrite(value, super.loadedOrders, () {
      super.loadedOrders = value;
    });
  }

  late final _$failureAtom =
      Atom(name: '_OrdersSearchControllerBase.failure', context: context);

  @override
  OrdersFailure? get failure {
    _$failureAtom.reportRead();
    return super.failure;
  }

  @override
  set failure(OrdersFailure? value) {
    _$failureAtom.reportWrite(value, super.failure, () {
      super.failure = value;
    });
  }

  late final _$clearSearchAsyncAction =
      AsyncAction('_OrdersSearchControllerBase.clearSearch', context: context);

  @override
  Future<void> clearSearch() {
    return _$clearSearchAsyncAction.run(() => super.clearSearch());
  }

  late final _$searchOrdersAsyncAction =
      AsyncAction('_OrdersSearchControllerBase.searchOrders', context: context);

  @override
  Future<void> searchOrders(Map<String, String> payload) {
    return _$searchOrdersAsyncAction.run(() => super.searchOrders(payload));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isLoaded: ${isLoaded},
loadedOrders: ${loadedOrders},
failure: ${failure}
    ''';
  }
}
