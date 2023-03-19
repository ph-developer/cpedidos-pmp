import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/helpers/map_helper.dart';
import '../../../../core/helpers/string_helper.dart';
import '../../domain/entities/service.dart';
import '../../domain/errors/failures.dart';
import '../../infra/datasources/service_catalog_datasource.dart';
import '../dtos/service_dto.dart';
import '../models/catser_model.dart';

class ServiceCatalogDatasourceImpl implements IServiceCatalogDatasource {
  final _assetPath = 'assets/catalog/catser.min.json';

  @override
  Future<Service> getServiceByCode(String code) async {
    final catser = await _loadCatser();
    final entries = catser.items.entries.where((entry) => entry.key == code);

    if (entries.isNotEmpty) {
      final entry = entries.first;
      return ServiceDTO.fromMapEntry(entry, catser.groups);
    }

    throw const ServiceNotFound();
  }

  @override
  Future<List<Service>> getServicesByDescription(String query) async {
    final catmat = await _loadCatser();

    return catmat.items.entries
        .where((entry) => entry.value[1].has(query) == true)
        .map((entry) => ServiceDTO.fromMapEntry(entry, catmat.groups))
        .toList();
  }

  @override
  Future<List<Service>> getServicesByGroupDescription(String query) async {
    final catser = await _loadCatser();
    final groupCodes = catser.groups.entries
        .where((entry) => entry.value.has(query))
        .map((entry) => entry.key)
        .map((code) => MapEntry(code, true))
        .toMap();

    if (groupCodes.isEmpty) return [];

    return catser.items.entries
        .where((entry) => groupCodes[entry.value[0]] ?? false)
        .map((entry) => ServiceDTO.fromMapEntry(entry, catser.groups))
        .toList();
  }

  Future<CatserModel> _loadCatser() async {
    final json = await rootBundle.loadString(_assetPath);
    final map = Map<String, dynamic>.from(jsonDecode(json));

    return CatserModel.fromMap(map);
  }
}
