import 'package:result_dart/result_dart.dart';

import '../entities/service.dart';
import '../errors/failures.dart';
import '../repositories/service_catalog_repository.dart';

abstract class IGetServicesByGroupDescription {
  AsyncResult<List<Service>, CatalogFailure> call(String query);
}

class GetServicesByGroupDescriptionImpl
    implements IGetServicesByGroupDescription {
  final IServiceCatalogRepository _serviceCatalogRepository;

  GetServicesByGroupDescriptionImpl(this._serviceCatalogRepository);

  @override
  AsyncResult<List<Service>, CatalogFailure> call(String query) async {
    if (query.isEmpty) {
      return const Failure(
        InvalidInput('O campo "descrição" deve ser preenchido.'),
      );
    }

    return _serviceCatalogRepository.getServicesByGroupDescription(query);
  }
}
