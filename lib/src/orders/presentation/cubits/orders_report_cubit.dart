import 'package:bloc/bloc.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/errors/failures.dart';
import '../../domain/usecases/get_all_orders_by_send_date.dart';

import 'orders_report_state.dart';

class OrdersReportCubit extends Cubit<OrdersReportState> {
  final IGetAllOrdersBySendDate _getAllOrdersBySendDate;

  OrdersReportCubit(
    this._getAllOrdersBySendDate,
  ) : super(InitialState());

  Future<void> reset() async {
    emit(InitialState());
  }

  Future<void> setDirty() async {
    emit(DirtyState());
  }

  Future<void> search(String sendDate) async {
    emit(LoadingState());

    await _getAllOrdersBySendDate(sendDate).fold((orders) {
      emit(LoadedState(orders: orders));
    }, (failure) {
      if (failure is OrdersNotFound) {
        emit(LoadedState(orders: const []));
      } else {
        emit(FailureState(failure: failure));
      }
    });
  }
}
