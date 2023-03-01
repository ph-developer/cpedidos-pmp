import 'package:result_dart/result_dart.dart';

import '../entities/service.dart';
import '../errors/failures.dart';
import '../repositories/service_catalog_repository.dart';

abstract class IGetServiceByCode {
  AsyncResult<Service, CatalogFailure> call(String code);
}

class GetServiceByCodeImpl implements IGetServiceByCode {
  final IServiceCatalogRepository _serviceCatalogRepository;

  GetServiceByCodeImpl(this._serviceCatalogRepository);

  @override
  AsyncResult<Service, CatalogFailure> call(String code) async {
    if (code.isEmpty) {
      return const Failure(
        InvalidInput('O campo "código" deve ser preenchido.'),
      );
    }

    return _serviceCatalogRepository.getServiceByCode(code);
  }
}
