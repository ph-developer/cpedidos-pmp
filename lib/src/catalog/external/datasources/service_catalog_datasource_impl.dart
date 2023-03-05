import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../shared/helpers/string_helper.dart';
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
      final services = await _searchInFile(
        '$_basePath/$file',
        (serviceMap) => serviceMap['code'] == code,
        metadata,
      );

      if (services.isNotEmpty) return services.first;
    }

    throw const ServiceNotFound();
  }

  @override
  Future<List<Service>> getServicesByDescription(String query) async {
    final metadata = await _loadMetadata();
    final services = <Service>[];

    for (final file in metadata.files) {
      final foundServices = await _searchInFile(
        '$_basePath/$file',
        (serviceMap) => serviceMap['description']?.has(query) == true,
        metadata,
      );

      services.addAll(foundServices);
    }

    return services;
  }

  Future<ServiceMetadataModel> _loadMetadata() async {
    final json = await rootBundle.loadString(_metaPath);
    final map = Map<String, dynamic>.from(jsonDecode(json));

    return ServiceMetadataModel.fromMap(map);
  }

  Future<Iterable<Service>> _searchInFile(
    String filePath,
    SearchTest test,
    ServiceMetadataModel metadata,
  ) async {
    final json = await rootBundle.loadString(filePath);
    final list = jsonDecode(json);

    return List<Map>.from(list)
        .map(Map<String, String>.from)
        .where(test)
        .map((map) => ServiceDTO.fromMap(map, metadata));
  }
}
