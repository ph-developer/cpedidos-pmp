// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items_search_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ItemsSearchController on _ItemsSearchControllerBase, Store {
  late final _$isLoadingAtom =
      Atom(name: '_ItemsSearchControllerBase.isLoading', context: context);

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
      Atom(name: '_ItemsSearchControllerBase.isLoaded', context: context);

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

  late final _$loadedItemsAtom =
      Atom(name: '_ItemsSearchControllerBase.loadedItems', context: context);

  @override
  ObservablePaginatedList<Item> get loadedItems {
    _$loadedItemsAtom.reportRead();
    return super.loadedItems;
  }

  @override
  set loadedItems(ObservablePaginatedList<Item> value) {
    _$loadedItemsAtom.reportWrite(value, super.loadedItems, () {
      super.loadedItems = value;
    });
  }

  late final _$failureAtom =
      Atom(name: '_ItemsSearchControllerBase.failure', context: context);

  @override
  CatalogFailure? get failure {
    _$failureAtom.reportRead();
    return super.failure;
  }

  @override
  set failure(CatalogFailure? value) {
    _$failureAtom.reportWrite(value, super.failure, () {
      super.failure = value;
    });
  }

  late final _$clearSearchAsyncAction =
      AsyncAction('_ItemsSearchControllerBase.clearSearch', context: context);

  @override
  Future<void> clearSearch() {
    return _$clearSearchAsyncAction.run(() => super.clearSearch());
  }

  late final _$searchItemsAsyncAction =
      AsyncAction('_ItemsSearchControllerBase.searchItems', context: context);

  @override
  Future<void> searchItems(Map<String, String> payload) {
    return _$searchItemsAsyncAction.run(() => super.searchItems(payload));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
isLoaded: ${isLoaded},
loadedItems: ${loadedItems},
failure: ${failure}
    ''';
  }
}
