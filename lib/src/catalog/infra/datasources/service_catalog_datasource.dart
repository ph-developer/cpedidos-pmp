import '../../domain/entities/service.dart';

abstract class IServiceCatalogDatasource {
  Future<Service> getServiceByCode(String code);
}
