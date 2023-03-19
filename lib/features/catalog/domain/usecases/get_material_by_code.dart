import 'package:result_dart/result_dart.dart';

import '../entities/material.dart';
import '../errors/failures.dart';
import '../repositories/material_catalog_repository.dart';

abstract class IGetMaterialByCode {
  AsyncResult<Material, CatalogFailure> call(String code);
}

class GetMaterialByCodeImpl implements IGetMaterialByCode {
  final IMaterialCatalogRepository _materialCatalogRepository;

  GetMaterialByCodeImpl(this._materialCatalogRepository);

  @override
  AsyncResult<Material, CatalogFailure> call(String code) async {
    if (code.isEmpty) {
      return const Failure(
        InvalidInput('O campo "código" deve ser preenchido.'),
      );
    }

    return _materialCatalogRepository.getMaterialByCode(code);
  }
}
