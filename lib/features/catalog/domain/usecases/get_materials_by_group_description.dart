import 'package:result_dart/result_dart.dart';

import '../entities/material.dart';
import '../errors/failures.dart';
import '../repositories/material_catalog_repository.dart';

abstract class IGetMaterialsByGroupDescription {
  AsyncResult<List<Material>, CatalogFailure> call(String query);
}

class GetMaterialsByGroupDescriptionImpl
    implements IGetMaterialsByGroupDescription {
  final IMaterialCatalogRepository _materialCatalogRepository;

  GetMaterialsByGroupDescriptionImpl(this._materialCatalogRepository);

  @override
  AsyncResult<List<Material>, CatalogFailure> call(String query) async {
    if (query.isEmpty) {
      return const Failure(
        InvalidInput('O campo "descrição do grupo" deve ser preenchido.'),
      );
    }

    return _materialCatalogRepository.getMaterialsByGroupDescription(query);
  }
}
