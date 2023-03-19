import 'package:result_dart/result_dart.dart';

import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/material.dart';
import '../../domain/errors/failures.dart';
import '../../domain/repositories/material_catalog_repository.dart';
import '../datasources/material_catalog_datasource.dart';

class MaterialCatalogRepositoryImpl implements IMaterialCatalogRepository {
  final IErrorHandler _errorHandler;
  final IMaterialCatalogDatasource _materialCatalogDatasource;

  MaterialCatalogRepositoryImpl(
    this._errorHandler,
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
      await _errorHandler.reportException(exception, stackTrace);
      return const Failure(UnknownError());
    }
  }

  @override
  AsyncResult<List<Material>, CatalogFailure> getMaterialsByDescription(
    String query,
  ) async {
    try {
      final material =
          await _materialCatalogDatasource.getMaterialsByDescription(query);

      return Success(material);
    } on CatalogFailure catch (failure) {
      return Failure(failure);
    } catch (exception, stackTrace) {
      await _errorHandler.reportException(exception, stackTrace);
      return const Failure(UnknownError());
    }
  }

  @override
  AsyncResult<List<Material>, CatalogFailure> getMaterialsByGroupDescription(
    String query,
  ) async {
    try {
      final material = await _materialCatalogDatasource
          .getMaterialsByGroupDescription(query);

      return Success(material);
    } on CatalogFailure catch (failure) {
      return Failure(failure);
    } catch (exception, stackTrace) {
      await _errorHandler.reportException(exception, stackTrace);
      return const Failure(UnknownError());
    }
  }
}
