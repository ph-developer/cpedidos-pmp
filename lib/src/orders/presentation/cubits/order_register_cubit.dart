import 'package:bloc/bloc.dart';

import '../../../shared/errors/failure.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/delete_order.dart';
import '../../domain/usecases/get_order_by_type_and_number.dart';
import '../../domain/usecases/save_order.dart';

import 'order_register_state.dart';

class OrderRegisterCubit extends Cubit<OrderRegisterState> {
  final ISaveOrder _saveOrder;
  final IDeleteOrder _deleteOrder;
  final IGetOrderByTypeAndNumber _getOrderByTypeAndNumber;

  OrderRegisterCubit(
    this._saveOrder,
    this._deleteOrder,
    this._getOrderByTypeAndNumber,
  ) : super(OrderRegisterInitialState());

  Future<void> reset() async {
    emit(OrderRegisterInitialState());
  }

  Future<void> setDirty() async {
    emit(OrderRegisterDirtyState());
  }

  Future<void> search(String type, String number) async {
    if (type.isEmpty || number.isEmpty) return;
    try {
      emit(OrderRegisterLoadingState());
      final loadedOrder = await _getOrderByTypeAndNumber(type, number);
      if (loadedOrder != null) {
        emit(OrderRegisterLoadedSuccessState(loadedOrder: loadedOrder));
      } else {
        emit(OrderRegisterLoadedEmptyState(
          typeQuery: type,
          numberQuery: number,
        ));
      }
    } on Failure catch (failure) {
      emit(OrderRegisterFailureState(failure: failure));
    }
  }

  Future<void> save(Order order) async {
    try {
      emit(OrderRegisterSavingState());
      await _saveOrder(order);
      emit(OrderRegisterSavedState());
    } on Failure catch (failure) {
      emit(OrderRegisterFailureState(failure: failure));
    }
  }

  Future<void> delete(Order order) async {
    try {
      emit(OrderRegisterDeletingState());
      await _deleteOrder(order);
      emit(OrderRegisterDeletedState());
    } on Failure catch (failure) {
      emit(OrderRegisterFailureState(failure: failure));
    }
  }
}
