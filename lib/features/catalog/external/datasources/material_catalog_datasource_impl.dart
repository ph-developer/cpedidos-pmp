import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/helpers/map_helper.dart';
import '../../../../core/helpers/string_helper.dart';
import '../../domain/entities/material.dart';
import '../../domain/errors/failures.dart';
import '../../infra/datasources/material_catalog_datasource.dart';
import '../dtos/material_dto.dart';
import '../models/catmat_model.dart';

class MaterialCatalogDatasourceImpl implements IMaterialCatalogDatasource {
  final _assetPath = 'assets/catalog/catmat.min.json';

  @override
  Future<Material> getMaterialByCode(String code) async {
    final catmat = await _loadCatmat();
    final entries = catmat.items.entries.where((entry) => entry.key == code);

    if (entries.isNotEmpty) {
      final entry = entries.first;
      return MaterialDTO.fromMapEntry(entry, catmat.groups);
    }

    throw const MaterialNotFound();
  }

  @override
  Future<List<Material>> getMaterialsByDescription(String query) async {
    final catmat = await _loadCatmat();

    return catmat.items.entries
        .where((entry) => entry.value[1].has(query) == true)
        .map((entry) => MaterialDTO.fromMapEntry(entry, catmat.groups))
        .toList();
  }

  @override
  Future<List<Material>> getMaterialsByGroupDescription(String query) async {
    final catmat = await _loadCatmat();
    final groupCodes = catmat.groups.entries
        .where((entry) => entry.value.has(query))
        .map((entry) => entry.key)
        .map((code) => MapEntry(code, true))
        .toMap();

    if (groupCodes.isEmpty) return [];

    return catmat.items.entries
        .where((entry) => groupCodes[entry.value[0]] ?? false)
        .map((entry) => MaterialDTO.fromMapEntry(entry, catmat.groups))
        .toList();
  }

  Future<CatmatModel> _loadCatmat() async {
    final json = await rootBundle.loadString(_assetPath);
    final map = Map<String, dynamic>.from(jsonDecode(json));

    return CatmatModel.fromMap(map);
  }
}
