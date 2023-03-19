import '../../domain/entities/service.dart';

abstract class IServiceCatalogDatasource {
  Future<Service> getServiceByCode(String code);
  Future<List<Service>> getServicesByDescription(String query);
  Future<List<Service>> getServicesByGroupDescription(String query);
}
