import 'package:bloc/bloc.dart';
import 'package:result_dart/result_dart.dart';

import '../../domain/errors/failures.dart';
import '../../domain/usecases/get_material_by_code.dart';
import '../../domain/usecases/get_materials_by_description.dart';
import '../../domain/usecases/get_service_by_code.dart';
import '../../domain/usecases/get_services_by_description.dart';
import 'items_search_state.dart';

class ItemsSearchCubit extends Cubit<ItemsSearchState> {
  final IGetMaterialByCode _getMaterialByCode;
  final IGetMaterialsByDescription _getMaterialsByDescription;
  final IGetServiceByCode _getServiceByCode;
  final IGetServicesByDescription _getServicesByDescription;

  ItemsSearchCubit(
    this._getMaterialByCode,
    this._getMaterialsByDescription,
    this._getServiceByCode,
    this._getServicesByDescription,
  ) : super(InitialState());

  Future<void> reset() async {
    emit(InitialState());
  }

  Future<void> setDirty() async {
    emit(DirtyState());
  }

  Future<void> search(
    String itemType,
    String searchType,
    String query,
  ) async {
    if (itemType == 'material') {
      if (searchType == 'code') {
        await _searchMaterialByCode(query);
      } else if (searchType == 'description') {
        await _searchMaterialByDescription(query);
      }
    } else if (itemType == 'service') {
      if (searchType == 'code') {
        await _searchServiceByCode(query);
      } else if (searchType == 'description') {
        await _searchServiceByDescription(query);
      }
    }
  }

  Future<void> _searchMaterialByCode(String code) async {
    emit(LoadingState());

    await _getMaterialByCode(code).fold((item) {
      emit(LoadedState(items: [item]));
    }, (failure) {
      if (failure is MaterialNotFound) {
        emit(LoadedState(items: const []));
      } else {
        emit(FailureState(failure: failure));
      }
    });
  }

  Future<void> _searchMaterialByDescription(String description) async {
    emit(LoadingState());

    await _getMaterialsByDescription(description).fold((items) {
      emit(LoadedState(items: items));
    }, (failure) {
      emit(FailureState(failure: failure));
    });
  }

  Future<void> _searchServiceByCode(String code) async {
    emit(LoadingState());

    await _getServiceByCode(code).fold((item) {
      emit(LoadedState(items: [item]));
    }, (failure) {
      if (failure is ServiceNotFound) {
        emit(LoadedState(items: const []));
      } else {
        emit(FailureState(failure: failure));
      }
    });
  }

  Future<void> _searchServiceByDescription(String description) async {
    emit(LoadingState());

    await _getServicesByDescription(description).fold((items) {
      emit(LoadedState(items: items));
    }, (failure) {
      emit(FailureState(failure: failure));
    });
  }
}
