// coverage:ignore-file

import 'package:flutter_modular/flutter_modular.dart';

import 'domain/repositories/material_catalog_repository.dart';
import 'domain/repositories/service_catalog_repository.dart';
import 'domain/usecases/get_material_by_code.dart';
import 'domain/usecases/get_service_by_code.dart';
import 'external/datasources/material_catalog_datasource_impl.dart';
import 'external/datasources/service_catalog_datasource_impl.dart';
import 'infra/datasources/material_catalog_datasource.dart';
import 'infra/datasources/service_catalog_datasource.dart';
import 'infra/repositories/material_catalog_repository_impl.dart';
import 'infra/repositories/service_catalog_repository_impl.dart';

class CatalogModule extends Module {
  @override
  List<ModularRoute> get routes => [];

  @override
  List<Bind<Object>> get binds => [
        //! External
        Bind.factory<IServiceCatalogDatasource>(
          (i) => ServiceCatalogDatasourceImpl(),
          export: true,
        ),
        Bind.factory<IMaterialCatalogDatasource>(
          (i) => MaterialCatalogDatasourceImpl(),
          export: true,
        ),

        //! Infra
        Bind.factory<IServiceCatalogRepository>(
          (i) => ServiceCatalogRepositoryImpl(i(), i()),
          export: true,
        ),
        Bind.factory<IMaterialCatalogRepository>(
          (i) => MaterialCatalogRepositoryImpl(i(), i()),
          export: true,
        ),

        //! Domain
        Bind.factory<IGetServiceByCode>(
          (i) => GetServiceByCodeImpl(i()),
          export: true,
        ),
        Bind.factory<IGetMaterialByCode>(
          (i) => GetMaterialByCodeImpl(i()),
          export: true,
        ),

        //! Presentation
      ];
}
