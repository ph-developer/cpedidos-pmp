import 'package:bloc/bloc.dart';

import '../../domain/entities/order.dart';
import '../../domain/errors/failures.dart';
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
  ) : super(InitialState());

  Future<void> reset() async {
    emit(InitialState());
  }

  Future<void> setDirty() async {
    emit(DirtyState());
  }

  Future<void> search(String type, String number) async {
    if (type.isEmpty || number.isEmpty) return;
    emit(LoadingState());

    final result = await _getOrderByTypeAndNumber(type, number);

    result.fold((loadedOrder) {
      emit(LoadedSuccessState(loadedOrder: loadedOrder));
    }, (failure) {
      if (failure is OrderNotFound) {
        emit(
          LoadedEmptyState(
            typeQuery: type,
            numberQuery: number,
          ),
        );
      } else {
        emit(FailureState(failure: failure));
      }
    });
  }

  Future<void> save(Order order) async {
    emit(SavingState());

    final result = await _saveOrder(order);

    result.fold((success) {
      emit(SavedState());
    }, (failure) {
      emit(FailureState(failure: failure));
    });
  }

  Future<void> delete(Order order) async {
    emit(DeletingState());

    final result = await _deleteOrder(order.type, order.number);

    result.fold((success) {
      emit(DeletedState());
    }, (failure) {
      emit(FailureState(failure: failure));
    });
  }
}
