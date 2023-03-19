import 'package:result_dart/result_dart.dart';

import '../entities/material.dart';
import '../errors/failures.dart';
import '../repositories/material_catalog_repository.dart';

abstract class IGetMaterialsByDescription {
  AsyncResult<List<Material>, CatalogFailure> call(String query);
}

class GetMaterialsByDescriptionImpl implements IGetMaterialsByDescription {
  final IMaterialCatalogRepository _materialCatalogRepository;

  GetMaterialsByDescriptionImpl(this._materialCatalogRepository);

  @override
  AsyncResult<List<Material>, CatalogFailure> call(String query) async {
    if (query.isEmpty) {
      return const Failure(
        InvalidInput('O campo "descrição" deve ser preenchido.'),
      );
    }

    return _materialCatalogRepository.getMaterialsByDescription(query);
  }
}
