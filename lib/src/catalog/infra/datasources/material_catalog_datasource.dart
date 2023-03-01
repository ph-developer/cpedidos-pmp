import '../../domain/entities/material.dart';

abstract class IMaterialCatalogDatasource {
  Future<Material> getMaterialByCode(String code);
}
