import 'package:result_dart/result_dart.dart';

import '../entities/material.dart';
import '../errors/failures.dart';

abstract class IMaterialCatalogRepository {
  AsyncResult<Material, CatalogFailure> getMaterialByCode(String code);
  AsyncResult<List<Material>, CatalogFailure> getMaterialsByDescription(
    String query,
  );
}
