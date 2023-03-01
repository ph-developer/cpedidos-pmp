import 'package:equatable/equatable.dart';

import '../../domain/entities/order.dart';
import '../../domain/errors/failures.dart';

abstract class OrdersSearchState extends Equatable {}

class InitialState extends OrdersSearchState {
  @override
  List<Object> get props => [];
}

class DirtyState extends OrdersSearchState {
  @override
  List<Object> get props => [];
}

class LoadingState extends OrdersSearchState {
  @override
  List<Object> get props => [];
}

class LoadedState extends OrdersSearchState {
  final List<Order> orders;

  LoadedState({required this.orders});

  @override
  List<Object> get props => [orders];
}

class FailureState extends OrdersSearchState {
  final OrdersFailure failure;

  FailureState({required this.failure});

  @override
  List<Object> get props => [failure];
}
