import 'package:result_dart/result_dart.dart';

import '../../../shared/services/error_service.dart';
import '../../domain/entities/service.dart';
import '../../domain/errors/failures.dart';
import '../../domain/repositories/service_catalog_repository.dart';
import '../datasources/service_catalog_datasource.dart';

class ServiceCatalogRepositoryImpl implements IServiceCatalogRepository {
  final IErrorService _errorService;
  final IServiceCatalogDatasource _serviceCatalogDatasource;

  ServiceCatalogRepositoryImpl(
    this._errorService,
    this._serviceCatalogDatasource,
  );

  @override
  AsyncResult<Service, CatalogFailure> getServiceByCode(String code) async {
    try {
      final service = await _serviceCatalogDatasource.getServiceByCode(code);

      return Success(service);
    } on CatalogFailure catch (failure) {
      return Failure(failure);
      // } catch (exception, stackTrace) {
      //   await _errorService.reportException(exception, stackTrace);
      //   return const Failure(UnknownError());
    }
  }
}
