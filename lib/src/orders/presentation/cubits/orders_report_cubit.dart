import 'package:bloc/bloc.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/errors/failures.dart';
import '../../domain/usecases/get_all_orders_by_send_date.dart';
import '../../domain/usecases/print_orders_report.dart';

import 'orders_report_state.dart';

class OrdersReportCubit extends Cubit<OrdersReportState> {
  final IGetAllOrdersBySendDate _getAllOrdersBySendDate;
  final IPrintOrdersReport _printOrdersReport;

  OrdersReportCubit(
    this._getAllOrdersBySendDate,
    this._printOrdersReport,
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

  Future<void> printReport() async {
    if (state is! LoadedState) return;
    final orders = (state as LoadedState).orders;
    if (orders.isEmpty) return;

    final result = await _printOrdersReport(orders);

    result.fold((success) {}, (failure) {
      emit(FailureState(failure: failure));
      emit(LoadedState(orders: orders));
    });
  }
}
