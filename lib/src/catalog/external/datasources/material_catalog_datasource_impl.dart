import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/material.dart';
import '../../domain/errors/failures.dart';
import '../../infra/datasources/material_catalog_datasource.dart';
import '../dtos/material_dto.dart';
import '../models/material_metadata_model.dart';

typedef SearchTest = bool Function(Map<String, String> materialMap);

class MaterialCatalogDatasourceImpl implements IMaterialCatalogDatasource {
  final _basePath = 'assets/catalog/catser';
  final _metaPath = 'assets/catalog/catser/meta.json';

  @override
  Future<Material> getMaterialByCode(String code) async {
    final metadata = await _loadMetadata();

    for (final file in metadata.files) {
      final material = await _searchInFile(
        '$_basePath/$file',
        (materialMap) => materialMap['code'] == code,
        metadata,
      );

      if (material != null) return material;
    }

    throw const MaterialNotFound();
  }

  Future<MaterialMetadataModel> _loadMetadata() async {
    final json = await rootBundle.loadString(_metaPath);
    final map = Map<String, dynamic>.from(jsonDecode(json));

    return MaterialMetadataModel.fromMap(map);
  }

  Future<Material?> _searchInFile(
    String filePath,
    SearchTest test,
    MaterialMetadataModel metadata,
  ) async {
    final json = await rootBundle.loadString(filePath);
    final list = jsonDecode(json);

    return List<Map>.from(list)
        .map(Map<String, String>.from)
        .where(test)
        .map((map) => MaterialDTO.fromMap(map, metadata))
        .firstOrNull;
  }
}
