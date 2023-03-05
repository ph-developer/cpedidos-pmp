import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../shared/helpers/string_helper.dart';
import '../../domain/entities/material.dart';
import '../../domain/errors/failures.dart';
import '../../infra/datasources/material_catalog_datasource.dart';
import '../dtos/material_dto.dart';
import '../models/material_metadata_model.dart';

typedef SearchTest = bool Function(Map<String, String> materialMap);

class MaterialCatalogDatasourceImpl implements IMaterialCatalogDatasource {
  final _basePath = 'assets/catalog/catmat';
  final _metaPath = 'assets/catalog/catmat/meta.json';

  @override
  Future<Material> getMaterialByCode(String code) async {
    final metadata = await _loadMetadata();

    for (final file in metadata.files) {
      final materials = await _searchInFile(
        '$_basePath/$file',
        (materialMap) => materialMap['code'] == code,
        metadata,
      );

      if (materials.isNotEmpty) return materials.first;
    }

    throw const MaterialNotFound();
  }

  @override
  Future<List<Material>> getMaterialsByDescription(String query) async {
    final metadata = await _loadMetadata();
    final materials = <Material>[];

    for (final file in metadata.files) {
      final foundMaterials = await _searchInFile(
        '$_basePath/$file',
        (serviceMap) => serviceMap['description']?.has(query) == true,
        metadata,
      );

      materials.addAll(foundMaterials);
    }

    return materials;
  }

  Future<MaterialMetadataModel> _loadMetadata() async {
    final json = await rootBundle.loadString(_metaPath);
    final map = Map<String, dynamic>.from(jsonDecode(json));

    return MaterialMetadataModel.fromMap(map);
  }

  Future<Iterable<Material>> _searchInFile(
    String filePath,
    SearchTest test,
    MaterialMetadataModel metadata,
  ) async {
    final json = await rootBundle.loadString(filePath);
    final list = jsonDecode(json);

    return List<Map>.from(list)
        .map(Map<String, String>.from)
        .where(test)
        .map((map) => MaterialDTO.fromMap(map, metadata));
  }
}
