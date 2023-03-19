import 'package:cpedidos_pmp/core/errors/error_handler.dart';
import 'package:cpedidos_pmp/features/catalog/domain/entities/material.dart';
import 'package:cpedidos_pmp/features/catalog/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/catalog/infra/datasources/material_catalog_datasource.dart';
import 'package:cpedidos_pmp/features/catalog/infra/repositories/material_catalog_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late IErrorHandler mockErrorHandler;
  late IMaterialCatalogDatasource mockMaterialCatalogDatasource;
  late MaterialCatalogRepositoryImpl repository;

  setUp(() {
    mockErrorHandler = MockErrorHandler();
    mockMaterialCatalogDatasource = MockMaterialCatalogDatasource();
    repository = MaterialCatalogRepositoryImpl(
      mockErrorHandler,
      mockMaterialCatalogDatasource,
    );
  });

  const tQuery = 'query';
  const tCode = 'itemCode';
  const tMaterial = Material(
    code: tCode,
    description: 'itemDescription',
    groupCode: 'groupCode',
    groupDescription: 'groupDescription',
  );
  final tCatalogFailure = MockCatalogFailure();

  group('getMaterialByCode', () {
    test(
      'should return a Material when material exists.',
      () async {
        // arrange
        when(() => mockMaterialCatalogDatasource.getMaterialByCode(tCode))
            .thenAnswer((_) async => tMaterial);
        // act
        final result = await repository.getMaterialByCode(tCode);
        // assert
        expect(result.getOrNull(), equals(tMaterial));
      },
    );

    test(
      'should return a known failure when datasource throws a known failure.',
      () async {
        // arrange
        when(() => mockMaterialCatalogDatasource.getMaterialByCode(tCode))
            .thenThrow(tCatalogFailure);
        // act
        final result = await repository.getMaterialByCode(tCode);
        // assert
        expect(result.exceptionOrNull(), equals(tCatalogFailure));
      },
    );

    test(
      'should report exception and return a failure on unknown exception.',
      () async {
        // arrange
        final tException = Exception('unknown');
        when(() => mockMaterialCatalogDatasource.getMaterialByCode(tCode))
            .thenThrow(tException);
        when(() => mockErrorHandler.reportException(tException, any()))
            .thenAnswer((_) async {});
        // act
        final result = await repository.getMaterialByCode(tCode);
        // assert
        verify(() => mockErrorHandler.reportException(tException, any()))
            .called(1);
        expect(result.exceptionOrNull(), isA<UnknownError>());
      },
    );
  });

  group('getMaterialsByDescription', () {
    test(
      'should return a Material list when at least one item that contains a '
      'description query exists.',
      () async {
        // arrange
        when(
          () => mockMaterialCatalogDatasource.getMaterialsByDescription(tQuery),
        ).thenAnswer((_) async => [tMaterial]);
        // act
        final result = await repository.getMaterialsByDescription(tQuery);
        // assert
        expect(result.getOrNull(), equals([tMaterial]));
      },
    );

    test(
      'should return a Material empty list when no one item that contains a '
      'description query exists.',
      () async {
        // arrange
        when(
          () => mockMaterialCatalogDatasource.getMaterialsByDescription(tQuery),
        ).thenAnswer((_) async => []);
        // act
        final result = await repository.getMaterialsByDescription(tQuery);
        // assert
        expect(result.getOrNull(), isA<List<Material>>());
        expect(result.getOrNull(), equals([]));
      },
    );

    test(
      'should return a known failure when datasource throws a known failure.',
      () async {
        // arrange
        when(
          () => mockMaterialCatalogDatasource.getMaterialsByDescription(tQuery),
        ).thenThrow(tCatalogFailure);
        // act
        final result = await repository.getMaterialsByDescription(tQuery);
        // assert
        expect(result.exceptionOrNull(), equals(tCatalogFailure));
      },
    );

    test(
      'should report exception and return a failure on unknown exception.',
      () async {
        // arrange
        final tException = Exception('unknown');
        when(
          () => mockMaterialCatalogDatasource.getMaterialsByDescription(tQuery),
        ).thenThrow(tException);
        when(() => mockErrorHandler.reportException(tException, any()))
            .thenAnswer((_) async {});
        // act
        final result = await repository.getMaterialsByDescription(tQuery);
        // assert
        verify(() => mockErrorHandler.reportException(tException, any()))
            .called(1);
        expect(result.exceptionOrNull(), isA<UnknownError>());
      },
    );
  });

  group('getMaterialsByGroupDescription', () {
    test(
      'should return a Material list when at least one item that contains a '
      'description query exists.',
      () async {
        // arrange
        when(
          () => mockMaterialCatalogDatasource
              .getMaterialsByGroupDescription(tQuery),
        ).thenAnswer((_) async => [tMaterial]);
        // act
        final result = await repository.getMaterialsByGroupDescription(tQuery);
        // assert
        expect(result.getOrNull(), equals([tMaterial]));
      },
    );

    test(
      'should return a Material empty list when no one item that contains a '
      'description query exists.',
      () async {
        // arrange
        when(
          () => mockMaterialCatalogDatasource
              .getMaterialsByGroupDescription(tQuery),
        ).thenAnswer((_) async => []);
        // act
        final result = await repository.getMaterialsByGroupDescription(tQuery);
        // assert
        expect(result.getOrNull(), isA<List<Material>>());
        expect(result.getOrNull(), equals([]));
      },
    );

    test(
      'should return a known failure when datasource throws a known failure.',
      () async {
        // arrange
        when(
          () => mockMaterialCatalogDatasource
              .getMaterialsByGroupDescription(tQuery),
        ).thenThrow(tCatalogFailure);
        // act
        final result = await repository.getMaterialsByGroupDescription(tQuery);
        // assert
        expect(result.exceptionOrNull(), equals(tCatalogFailure));
      },
    );

    test(
      'should report exception and return a failure on unknown exception.',
      () async {
        // arrange
        final tException = Exception('unknown');
        when(
          () => mockMaterialCatalogDatasource
              .getMaterialsByGroupDescription(tQuery),
        ).thenThrow(tException);
        when(() => mockErrorHandler.reportException(tException, any()))
            .thenAnswer((_) async {});
        // act
        final result = await repository.getMaterialsByGroupDescription(tQuery);
        // assert
        verify(() => mockErrorHandler.reportException(tException, any()))
            .called(1);
        expect(result.exceptionOrNull(), isA<UnknownError>());
      },
    );
  });
}
