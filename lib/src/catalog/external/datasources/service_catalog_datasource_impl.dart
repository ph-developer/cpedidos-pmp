import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';

import '../../domain/entities/service.dart';
import '../../domain/errors/failures.dart';
import '../../infra/datasources/service_catalog_datasource.dart';
import '../dtos/service_dto.dart';
import '../models/service_metadata_model.dart';

typedef SearchTest = bool Function(Map<String, String> serviceMap);

class ServiceCatalogDatasourceImpl implements IServiceCatalogDatasource {
  final _basePath = 'assets/catalog/catser';
  final _metaPath = 'assets/catalog/catser/meta.json';

  @override
  Future<Service> getServiceByCode(String code) async {
    final metadata = await _loadMetadata();

    for (final file in metadata.files) {
      final service = await _searchInFile(
        '$_basePath/$file',
        (serviceMap) => serviceMap['code'] == code,
        metadata,
      );

      if (service != null) return service;
    }

    throw const ServiceNotFound();
  }

  Future<ServiceMetadataModel> _loadMetadata() async {
    final json = await rootBundle.loadString(_metaPath);
    final map = Map<String, dynamic>.from(jsonDecode(json));

    return ServiceMetadataModel.fromMap(map);
  }

  Future<Service?> _searchInFile(
    String filePath,
    SearchTest test,
    ServiceMetadataModel metadata,
  ) async {
    final json = await rootBundle.loadString(filePath);
    final list = jsonDecode(json);

    return List<Map>.from(list)
        .map(Map<String, String>.from)
        .where(test)
        .map((map) => ServiceDTO.fromMap(map, metadata))
        .firstOrNull;
  }
}
