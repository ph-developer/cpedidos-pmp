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
  ) : super(OrdersReportInitialState());

  Future<void> reset() async {
    emit(OrdersReportInitialState());
  }

  Future<void> setDirty() async {
    emit(OrdersReportDirtyState());
  }

  Future<void> search(String sendDate) async {
    emit(OrdersReportLoadingState());

    await _getAllOrdersBySendDate(sendDate).fold((orders) {
      emit(OrdersReportLoadedState(orders: orders));
    }, (failure) {
      if (failure is OrdersNotFound) {
        emit(OrdersReportLoadedState(orders: const []));
      } else {
        emit(OrdersReportFailureState(failure: failure));
      }
    });
  }

  Future<void> printReport() async {
    if (state is! OrdersReportLoadedState) return;
    final orders = (state as OrdersReportLoadedState).orders;
    if (orders.isEmpty) return;

    final result = await _printOrdersReport(orders);

    result.fold((success) {}, (failure) {
      emit(OrdersReportFailureState(failure: failure));
      emit(OrdersReportLoadedState(orders: orders));
    });
  }
}
