import 'package:result_dart/result_dart.dart';

import '../entities/service.dart';
import '../errors/failures.dart';

abstract class IServiceCatalogRepository {
  AsyncResult<Service, CatalogFailure> getServiceByCode(String code);
  AsyncResult<List<Service>, CatalogFailure> getServicesByDescription(
    String query,
  );
}
