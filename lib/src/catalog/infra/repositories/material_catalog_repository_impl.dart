import 'package:result_dart/result_dart.dart';

import '../../../shared/services/error_service.dart';
import '../../domain/entities/material.dart';
import '../../domain/errors/failures.dart';
import '../../domain/repositories/material_catalog_repository.dart';
import '../datasources/material_catalog_datasource.dart';

class MaterialCatalogRepositoryImpl implements IMaterialCatalogRepository {
  final IErrorService _errorService;
  final IMaterialCatalogDatasource _materialCatalogDatasource;

  MaterialCatalogRepositoryImpl(
    this._errorService,
    this._materialCatalogDatasource,
  );

  @override
  AsyncResult<Material, CatalogFailure> getMaterialByCode(String code) async {
    try {
      final material = await _materialCatalogDatasource.getMaterialByCode(code);

      return Success(material);
    } on CatalogFailure catch (failure) {
      return Failure(failure);
    } catch (exception, stackTrace) {
      await _errorService.reportException(exception, stackTrace);
      return const Failure(UnknownError());
    }
  }
}
