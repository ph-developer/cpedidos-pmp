// ignore_for_file: library_private_types_in_public_api

import 'package:mobx/mobx.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../core/reactivity/obs_paginated_list.dart';
import '../../domain/entities/item.dart';
import '../../domain/errors/failures.dart';
import '../../domain/usecases/get_material_by_code.dart';
import '../../domain/usecases/get_materials_by_description.dart';
import '../../domain/usecases/get_materials_by_group_description.dart';
import '../../domain/usecases/get_service_by_code.dart';
import '../../domain/usecases/get_services_by_description.dart';
import '../../domain/usecases/get_services_by_group_description.dart';

part 'items_search_controller.g.dart';

class ItemsSearchController = _ItemsSearchControllerBase
    with _$ItemsSearchController;

abstract class _ItemsSearchControllerBase with Store {
  final IGetMaterialByCode _getMaterialByCode;
  final IGetMaterialsByDescription _getMaterialsByDescription;
  final IGetMaterialsByGroupDescription _getMaterialsByGroupDescription;
  final IGetServiceByCode _getServiceByCode;
  final IGetServicesByDescription _getServicesByDescription;
  final IGetServicesByGroupDescription _getServicesByGroupDescription;

  _ItemsSearchControllerBase(
    this._getMaterialByCode,
    this._getMaterialsByDescription,
    this._getMaterialsByGroupDescription,
    this._getServiceByCode,
    this._getServicesByDescription,
    this._getServicesByGroupDescription,
  );

  @observable
  bool isLoading = false;

  @observable
  bool isLoaded = false;

  @observable
  ObservablePaginatedList<Item> loadedItems = ObservablePaginatedList.of([]);

  @observable
  CatalogFailure? failure;

  @action
  Future<void> clearSearch() async {
    isLoading = true;
    loadedItems.clear();
    isLoaded = false;
    isLoading = false;
  }

  @action
  Future<void> searchItems(Map<String, String> payload) async {
    isLoading = true;
    failure = null;
    loadedItems.clear();

    final itemType = payload['itemType'] ?? '';
    final searchType = payload['searchType'] ?? '';
    final query = payload['query'] ?? '';

    AsyncResult<List<Item>, CatalogFailure>? usecase;

    if (itemType == 'material') {
      if (searchType == 'code') {
        usecase = _getMaterialByCode(query).map((item) => [item]);
      } else if (searchType == 'description') {
        usecase = _getMaterialsByDescription(query);
      } else if (searchType == 'groupDescription') {
        usecase = _getMaterialsByGroupDescription(query);
      }
    } else if (itemType == 'service') {
      if (searchType == 'code') {
        usecase = _getServiceByCode(query).map((item) => [item]);
      } else if (searchType == 'description') {
        usecase = _getServicesByDescription(query);
      } else if (searchType == 'groupDescription') {
        usecase = _getServicesByGroupDescription(query);
      }
    }

    if (usecase != null) {
      final result = await usecase;
      result.fold(
        loadedItems.addAll,
        (failure) => this.failure = failure,
      );
      isLoaded = true;
    }

    isLoading = false;
  }
}
