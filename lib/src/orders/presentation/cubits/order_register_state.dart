import 'package:equatable/equatable.dart';

import '../../domain/entities/order.dart';
import '../../domain/errors/failures.dart';

abstract class OrderRegisterState extends Equatable {}

class InitialState extends OrderRegisterState {
  @override
  List<Object> get props => [];
}

class DirtyState extends OrderRegisterState {
  @override
  List<Object> get props => [];
}

class LoadingState extends OrderRegisterState {
  @override
  List<Object> get props => [];
}

class LoadedSuccessState extends OrderRegisterState {
  final Order loadedOrder;

  LoadedSuccessState({required this.loadedOrder});

  @override
  List<Object> get props => [loadedOrder];
}

class LoadedEmptyState extends OrderRegisterState {
  final String numberQuery;
  final String typeQuery;

  LoadedEmptyState({
    required this.numberQuery,
    required this.typeQuery,
  });

  @override
  List<Object> get props => [numberQuery, typeQuery];
}

class SavingState extends OrderRegisterState {
  @override
  List<Object> get props => [];
}

class SavedState extends OrderRegisterState {
  @override
  List<Object> get props => [];
}

class DeletingState extends OrderRegisterState {
  @override
  List<Object> get props => [];
}

class DeletedState extends OrderRegisterState {
  @override
  List<Object> get props => [];
}

class FailureState extends OrderRegisterState {
  final OrdersFailure failure;

  FailureState({required this.failure});

  @override
  List<Object> get props => [failure];
}
