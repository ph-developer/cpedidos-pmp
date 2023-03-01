import 'package:bloc/bloc.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/errors/failures.dart';
import '../../domain/usecases/get_all_orders_by_arrival_date.dart';
import '../../domain/usecases/get_all_orders_by_send_date.dart';

import 'orders_search_state.dart';

class OrdersSearchCubit extends Cubit<OrdersSearchState> {
  final IGetAllOrdersBySendDate _getAllOrdersBySendDate;
  final IGetAllOrdersByArrivalDate _getAllOrdersByArrivalDate;

  OrdersSearchCubit(
    this._getAllOrdersBySendDate,
    this._getAllOrdersByArrivalDate,
  ) : super(InitialState());

  Future<void> reset() async {
    emit(InitialState());
  }

  Future<void> setDirty() async {
    emit(DirtyState());
  }

  Future<void> search(String searchType, String query) async {
    switch (searchType) {
      case 'sendDate':
        return _searchBySendDate(searchType, query);
      case 'arrivalDate':
        return _searchByArrivalDate(searchType, query);
      default:
        return;
    }
  }

  Future<void> _searchBySendDate(String searchType, String query) async {
    emit(LoadingState());

    await _getAllOrdersBySendDate(query).fold((orders) {
      emit(LoadedState(orders: orders));
    }, (failure) {
      if (failure is OrdersNotFound) {
        emit(LoadedState(orders: const []));
      } else {
        emit(FailureState(failure: failure));
      }
    });
  }

  Future<void> _searchByArrivalDate(String searchType, String query) async {
    emit(LoadingState());

    await _getAllOrdersByArrivalDate(query).fold((orders) {
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
