// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../shared/errors/failure.dart';
import '../../domain/entities/order.dart';

abstract class OrderRegisterState extends Equatable {}

class OrderRegisterInitialState extends OrderRegisterState {
  @override
  List<Object> get props => [];
}

class OrderRegisterDirtyState extends OrderRegisterState {
  @override
  List<Object> get props => [];
}

class OrderRegisterLoadingState extends OrderRegisterState {
  @override
  List<Object> get props => [];
}

class OrderRegisterLoadedSuccessState extends OrderRegisterState {
  final Order loadedOrder;

  OrderRegisterLoadedSuccessState({required this.loadedOrder});

  @override
  List<Object> get props => [loadedOrder];
}

class OrderRegisterLoadedEmptyState extends OrderRegisterState {
  final String numberQuery;
  final String typeQuery;

  OrderRegisterLoadedEmptyState({
    required this.numberQuery,
    required this.typeQuery,
  });

  @override
  List<Object> get props => [numberQuery, typeQuery];
}

class OrderRegisterSavingState extends OrderRegisterState {
  @override
  List<Object> get props => [];
}

class OrderRegisterSavedState extends OrderRegisterState {
  @override
  List<Object> get props => [];
}

class OrderRegisterDeletingState extends OrderRegisterState {
  @override
  List<Object> get props => [];
}

class OrderRegisterDeletedState extends OrderRegisterState {
  @override
  List<Object> get props => [];
}

class OrderRegisterFailureState extends OrderRegisterState {
  final Failure failure;

  OrderRegisterFailureState({required this.failure});

  @override
  List<Object> get props => [failure];
}
