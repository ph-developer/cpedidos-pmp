import 'package:equatable/equatable.dart';

import '../../domain/entities/order.dart';
import '../../domain/errors/failures.dart';

abstract class OrdersReportState extends Equatable {}

class InitialState extends OrdersReportState {
  @override
  List<Object> get props => [];
}

class DirtyState extends OrdersReportState {
  @override
  List<Object> get props => [];
}

class LoadingState extends OrdersReportState {
  @override
  List<Object> get props => [];
}

class LoadedState extends OrdersReportState {
  final List<Order> orders;

  LoadedState({required this.orders});

  @override
  List<Object> get props => [orders];
}

class FailureState extends OrdersReportState {
  final OrdersFailure failure;

  FailureState({required this.failure});

  @override
  List<Object> get props => [failure];
}
