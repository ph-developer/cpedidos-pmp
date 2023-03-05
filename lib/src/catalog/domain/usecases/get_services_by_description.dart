import 'package:result_dart/result_dart.dart';

import '../entities/service.dart';
import '../errors/failures.dart';
import '../repositories/service_catalog_repository.dart';

abstract class IGetServicesByDescription {
  AsyncResult<List<Service>, CatalogFailure> call(String query);
}

class GetServicesByDescriptionImpl implements IGetServicesByDescription {
  final IServiceCatalogRepository _serviceCatalogRepository;

  GetServicesByDescriptionImpl(this._serviceCatalogRepository);

  @override
  AsyncResult<List<Service>, CatalogFailure> call(String query) async {
    if (query.isEmpty) {
      return const Failure(
        InvalidInput('O campo "descrição" deve ser preenchido.'),
      );
    }

    return _serviceCatalogRepository.getServicesByDescription(query);
  }
}
