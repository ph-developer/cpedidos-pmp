import 'package:equatable/equatable.dart';

import '../../domain/entities/order.dart';
import '../../domain/errors/failures.dart';

abstract class OrdersReportState extends Equatable {}

class OrdersReportInitialState extends OrdersReportState {
  @override
  List<Object> get props => [];
}

class OrdersReportDirtyState extends OrdersReportState {
  @override
  List<Object> get props => [];
}

class OrdersReportLoadingState extends OrdersReportState {
  @override
  List<Object> get props => [];
}

class OrdersReportLoadedState extends OrdersReportState {
  final List<Order> orders;

  OrdersReportLoadedState({required this.orders});

  @override
  List<Object> get props => [orders];
}

class OrdersReportFailureState extends OrdersReportState {
  final OrdersFailure failure;

  OrdersReportFailureState({required this.failure});

  @override
  List<Object> get props => [failure];
}
