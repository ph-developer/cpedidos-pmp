// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_register_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$OrderRegisterController on _OrderRegisterControllerBase, Store {
  late final _$isSearchingAtom =
      Atom(name: '_OrderRegisterControllerBase.isSearching', context: context);

  @override
  bool get isSearching {
    _$isSearchingAtom.reportRead();
    return super.isSearching;
  }

  @override
  set isSearching(bool value) {
    _$isSearchingAtom.reportWrite(value, super.isSearching, () {
      super.isSearching = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_OrderRegisterControllerBase.isLoading', context: context);

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
      Atom(name: '_OrderRegisterControllerBase.isLoaded', context: context);

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

  late final _$loadedOrderAtom =
      Atom(name: '_OrderRegisterControllerBase.loadedOrder', context: context);

  @override
  Order? get loadedOrder {
    _$loadedOrderAtom.reportRead();
    return super.loadedOrder;
  }

  @override
  set loadedOrder(Order? value) {
    _$loadedOrderAtom.reportWrite(value, super.loadedOrder, () {
      super.loadedOrder = value;
    });
  }

  late final _$currentQueryAtom =
      Atom(name: '_OrderRegisterControllerBase.currentQuery', context: context);

  @override
  Map<String, String>? get currentQuery {
    _$currentQueryAtom.reportRead();
    return super.currentQuery;
  }

  @override
  set currentQuery(Map<String, String>? value) {
    _$currentQueryAtom.reportWrite(value, super.currentQuery, () {
      super.currentQuery = value;
    });
  }

  late final _$failureAtom =
      Atom(name: '_OrderRegisterControllerBase.failure', context: context);

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

  late final _$successAtom =
      Atom(name: '_OrderRegisterControllerBase.success', context: context);

  @override
  SuccessfulAction? get success {
    _$successAtom.reportRead();
    return super.success;
  }

  @override
  set success(SuccessfulAction? value) {
    _$successAtom.reportWrite(value, super.success, () {
      super.success = value;
    });
  }

  late final _$clearSearchAsyncAction =
      AsyncAction('_OrderRegisterControllerBase.clearSearch', context: context);

  @override
  Future<void> clearSearch() {
    return _$clearSearchAsyncAction.run(() => super.clearSearch());
  }

  late final _$searchOrderAsyncAction =
      AsyncAction('_OrderRegisterControllerBase.searchOrder', context: context);

  @override
  Future<void> searchOrder(Map<String, String> payload) {
    return _$searchOrderAsyncAction.run(() => super.searchOrder(payload));
  }

  late final _$_searchOrderAsyncAction = AsyncAction(
      '_OrderRegisterControllerBase._searchOrder',
      context: context);

  @override
  Future<void> _searchOrder(
      String type, String number, Map<String, String> query) {
    return _$_searchOrderAsyncAction
        .run(() => super._searchOrder(type, number, query));
  }

  late final _$saveOrderAsyncAction =
      AsyncAction('_OrderRegisterControllerBase.saveOrder', context: context);

  @override
  Future<void> saveOrder(Map<String, String> payload) {
    return _$saveOrderAsyncAction.run(() => super.saveOrder(payload));
  }

  late final _$deleteOrderAsyncAction =
      AsyncAction('_OrderRegisterControllerBase.deleteOrder', context: context);

  @override
  Future<void> deleteOrder(Map<String, String> payload) {
    return _$deleteOrderAsyncAction.run(() => super.deleteOrder(payload));
  }

  @override
  String toString() {
    return '''
isSearching: ${isSearching},
isLoading: ${isLoading},
isLoaded: ${isLoaded},
loadedOrder: ${loadedOrder},
currentQuery: ${currentQuery},
failure: ${failure},
success: ${success}
    ''';
  }
}
