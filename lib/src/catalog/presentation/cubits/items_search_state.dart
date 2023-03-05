import 'package:equatable/equatable.dart';

import '../../domain/entities/item.dart';
import '../../domain/errors/failures.dart';

abstract class ItemsSearchState extends Equatable {}

class InitialState extends ItemsSearchState {
  @override
  List<Object> get props => [];
}

class DirtyState extends ItemsSearchState {
  @override
  List<Object> get props => [];
}

class LoadingState extends ItemsSearchState {
  @override
  List<Object> get props => [];
}

class LoadedState extends ItemsSearchState {
  final List<Item> items;

  LoadedState({required this.items});

  @override
  List<Object> get props => [items];
}

class FailureState extends ItemsSearchState {
  final CatalogFailure failure;

  FailureState({required this.failure});

  @override
  List<Object> get props => [failure];
}
