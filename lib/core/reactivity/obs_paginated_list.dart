// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';

part 'obs_paginated_list.g.dart';

class ObservablePaginatedList<T> = _ObservablePaginatedListBase<T>
    with _$ObservablePaginatedList<T>;

abstract class _ObservablePaginatedListBase<T> with Store {
  _ObservablePaginatedListBase.of(
    Iterable<T> elements, [
    int maxItemsByPage = 20,
  ])  : _list = ObservableList.of(elements),
        _maxItemsByPage = maxItemsByPage;

  final ObservableList<T> _list;

  @observable
  int _maxItemsByPage;

  @observable
  int _currentPage = 1;

  @computed
  Iterable<T> get all => _list;

  @computed
  Iterable<T> get paginated =>
      _list.skip((_currentPage - 1) * _maxItemsByPage).take(_maxItemsByPage);

  @computed
  int get currentPage => _currentPage;

  @computed
  int get pagesCount => (_list.length / _maxItemsByPage).ceil();

  @computed
  int get length => _list.length;

  @computed
  bool get isEmpty => _list.isEmpty;

  @computed
  bool get isNotEmpty => _list.isNotEmpty;

  @action
  void setMaxItemsByPage(int maxItemsByPage) {
    if (maxItemsByPage > 0) {
      _maxItemsByPage = maxItemsByPage;

      if (_currentPage > pagesCount) {
        _currentPage = pagesCount;
      }
    }
  }

  @action
  void previousPage() {
    if (_currentPage > 1) {
      _currentPage = currentPage - 1;
    }
  }

  @action
  void nextPage() {
    if (_currentPage < pagesCount) {
      _currentPage = currentPage + 1;
    }
  }

  @action
  void addAll(Iterable<T> iterable) {
    _list.addAll(iterable);
  }

  @action
  void clear() {
    _list.clear();
    _currentPage = 1;
  }
}
