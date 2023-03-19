import '../../domain/entities/material.dart';

abstract class IMaterialCatalogDatasource {
  Future<Material> getMaterialByCode(String code);
  Future<List<Material>> getMaterialsByDescription(String query);
  Future<List<Material>> getMaterialsByGroupDescription(String query);
}
