// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'obs_paginated_list.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ObservablePaginatedList<T> on _ObservablePaginatedListBase<T>, Store {
  Computed<Iterable<T>>? _$allComputed;

  @override
  Iterable<T> get all =>
      (_$allComputed ??= Computed<Iterable<T>>(() => super.all,
              name: '_ObservablePaginatedListBase.all'))
          .value;
  Computed<Iterable<T>>? _$paginatedComputed;

  @override
  Iterable<T> get paginated =>
      (_$paginatedComputed ??= Computed<Iterable<T>>(() => super.paginated,
              name: '_ObservablePaginatedListBase.paginated'))
          .value;
  Computed<int>? _$currentPageComputed;

  @override
  int get currentPage =>
      (_$currentPageComputed ??= Computed<int>(() => super.currentPage,
              name: '_ObservablePaginatedListBase.currentPage'))
          .value;
  Computed<int>? _$pagesCountComputed;

  @override
  int get pagesCount =>
      (_$pagesCountComputed ??= Computed<int>(() => super.pagesCount,
              name: '_ObservablePaginatedListBase.pagesCount'))
          .value;
  Computed<int>? _$lengthComputed;

  @override
  int get length => (_$lengthComputed ??= Computed<int>(() => super.length,
          name: '_ObservablePaginatedListBase.length'))
      .value;
  Computed<bool>? _$isEmptyComputed;

  @override
  bool get isEmpty => (_$isEmptyComputed ??= Computed<bool>(() => super.isEmpty,
          name: '_ObservablePaginatedListBase.isEmpty'))
      .value;
  Computed<bool>? _$isNotEmptyComputed;

  @override
  bool get isNotEmpty =>
      (_$isNotEmptyComputed ??= Computed<bool>(() => super.isNotEmpty,
              name: '_ObservablePaginatedListBase.isNotEmpty'))
          .value;

  late final _$_maxItemsByPageAtom = Atom(
      name: '_ObservablePaginatedListBase._maxItemsByPage', context: context);

  @override
  int get _maxItemsByPage {
    _$_maxItemsByPageAtom.reportRead();
    return super._maxItemsByPage;
  }

  @override
  set _maxItemsByPage(int value) {
    _$_maxItemsByPageAtom.reportWrite(value, super._maxItemsByPage, () {
      super._maxItemsByPage = value;
    });
  }

  late final _$_currentPageAtom =
      Atom(name: '_ObservablePaginatedListBase._currentPage', context: context);

  @override
  int get _currentPage {
    _$_currentPageAtom.reportRead();
    return super._currentPage;
  }

  @override
  set _currentPage(int value) {
    _$_currentPageAtom.reportWrite(value, super._currentPage, () {
      super._currentPage = value;
    });
  }

  late final _$_ObservablePaginatedListBaseActionController =
      ActionController(name: '_ObservablePaginatedListBase', context: context);

  @override
  void setMaxItemsByPage(int maxItemsByPage) {
    final _$actionInfo = _$_ObservablePaginatedListBaseActionController
        .startAction(name: '_ObservablePaginatedListBase.setMaxItemsByPage');
    try {
      return super.setMaxItemsByPage(maxItemsByPage);
    } finally {
      _$_ObservablePaginatedListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void previousPage() {
    final _$actionInfo = _$_ObservablePaginatedListBaseActionController
        .startAction(name: '_ObservablePaginatedListBase.previousPage');
    try {
      return super.previousPage();
    } finally {
      _$_ObservablePaginatedListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void nextPage() {
    final _$actionInfo = _$_ObservablePaginatedListBaseActionController
        .startAction(name: '_ObservablePaginatedListBase.nextPage');
    try {
      return super.nextPage();
    } finally {
      _$_ObservablePaginatedListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addAll(Iterable<T> iterable) {
    final _$actionInfo = _$_ObservablePaginatedListBaseActionController
        .startAction(name: '_ObservablePaginatedListBase.addAll');
    try {
      return super.addAll(iterable);
    } finally {
      _$_ObservablePaginatedListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void clear() {
    final _$actionInfo = _$_ObservablePaginatedListBaseActionController
        .startAction(name: '_ObservablePaginatedListBase.clear');
    try {
      return super.clear();
    } finally {
      _$_ObservablePaginatedListBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
all: ${all},
paginated: ${paginated},
currentPage: ${currentPage},
pagesCount: ${pagesCount},
length: ${length},
isEmpty: ${isEmpty},
isNotEmpty: ${isNotEmpty}
    ''';
  }
}
