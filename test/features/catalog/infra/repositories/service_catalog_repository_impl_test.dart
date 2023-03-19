import 'package:cpedidos_pmp/core/errors/error_handler.dart';
import 'package:cpedidos_pmp/features/catalog/domain/entities/service.dart';
import 'package:cpedidos_pmp/features/catalog/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/catalog/infra/datasources/service_catalog_datasource.dart';
import 'package:cpedidos_pmp/features/catalog/infra/repositories/service_catalog_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  late IErrorHandler mockErrorHandler;
  late IServiceCatalogDatasource mockServiceCatalogDatasource;
  late ServiceCatalogRepositoryImpl repository;

  setUp(() {
    mockErrorHandler = MockErrorHandler();
    mockServiceCatalogDatasource = MockServiceCatalogDatasource();
    repository = ServiceCatalogRepositoryImpl(
      mockErrorHandler,
      mockServiceCatalogDatasource,
    );
  });

  const tQuery = 'query';
  const tCode = 'itemCode';
  const tService = Service(
    code: tCode,
    description: 'itemDescription',
    groupCode: 'groupCode',
    groupDescription: 'groupDescription',
  );
  final tCatalogFailure = MockCatalogFailure();

  group('getServiceByCode', () {
    test(
      'should return a Service when service exists.',
      () async {
        // arrange
        when(() => mockServiceCatalogDatasource.getServiceByCode(tCode))
            .thenAnswer((_) async => tService);
        // act
        final result = await repository.getServiceByCode(tCode);
        // assert
        expect(result.getOrNull(), equals(tService));
      },
    );

    test(
      'should return a known failure when datasource throws a known failure.',
      () async {
        // arrange
        when(() => mockServiceCatalogDatasource.getServiceByCode(tCode))
            .thenThrow(tCatalogFailure);
        // act
        final result = await repository.getServiceByCode(tCode);
        // assert
        expect(result.exceptionOrNull(), equals(tCatalogFailure));
      },
    );

    test(
      'should report exception and return a failure on unknown exception.',
      () async {
        // arrange
        final tException = Exception('unknown');
        when(() => mockServiceCatalogDatasource.getServiceByCode(tCode))
            .thenThrow(tException);
        when(() => mockErrorHandler.reportException(tException, any()))
            .thenAnswer((_) async {});
        // act
        final result = await repository.getServiceByCode(tCode);
        // assert
        verify(() => mockErrorHandler.reportException(tException, any()))
            .called(1);
        expect(result.exceptionOrNull(), isA<UnknownError>());
      },
    );
  });

  group('getServicesByDescription', () {
    test(
      'should return a Service list when at least one item that contains a '
      'description query exists.',
      () async {
        // arrange
        when(
          () => mockServiceCatalogDatasource.getServicesByDescription(tQuery),
        ).thenAnswer((_) async => [tService]);
        // act
        final result = await repository.getServicesByDescription(tQuery);
        // assert
        expect(result.getOrNull(), equals([tService]));
      },
    );

    test(
      'should return a Service empty list when no one item that contains a '
      'description query exists.',
      () async {
        // arrange
        when(
          () => mockServiceCatalogDatasource.getServicesByDescription(tQuery),
        ).thenAnswer((_) async => []);
        // act
        final result = await repository.getServicesByDescription(tQuery);
        // assert
        expect(result.getOrNull(), isA<List<Service>>());
        expect(result.getOrNull(), equals([]));
      },
    );

    test(
      'should return a known failure when datasource throws a known failure.',
      () async {
        // arrange
        when(
          () => mockServiceCatalogDatasource.getServicesByDescription(tQuery),
        ).thenThrow(tCatalogFailure);
        // act
        final result = await repository.getServicesByDescription(tQuery);
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
          () => mockServiceCatalogDatasource.getServicesByDescription(tQuery),
        ).thenThrow(tException);
        when(() => mockErrorHandler.reportException(tException, any()))
            .thenAnswer((_) async {});
        // act
        final result = await repository.getServicesByDescription(tQuery);
        // assert
        verify(() => mockErrorHandler.reportException(tException, any()))
            .called(1);
        expect(result.exceptionOrNull(), isA<UnknownError>());
      },
    );
  });

  group('getServicesByGroupDescription', () {
    test(
      'should return a Service list when at least one item that contains a '
      'description query exists.',
      () async {
        // arrange
        when(
          () => mockServiceCatalogDatasource
              .getServicesByGroupDescription(tQuery),
        ).thenAnswer((_) async => [tService]);
        // act
        final result = await repository.getServicesByGroupDescription(tQuery);
        // assert
        expect(result.getOrNull(), equals([tService]));
      },
    );

    test(
      'should return a Service empty list when no one item that contains a '
      'description query exists.',
      () async {
        // arrange
        when(
          () => mockServiceCatalogDatasource
              .getServicesByGroupDescription(tQuery),
        ).thenAnswer((_) async => []);
        // act
        final result = await repository.getServicesByGroupDescription(tQuery);
        // assert
        expect(result.getOrNull(), isA<List<Service>>());
        expect(result.getOrNull(), equals([]));
      },
    );

    test(
      'should return a known failure when datasource throws a known failure.',
      () async {
        // arrange
        when(
          () => mockServiceCatalogDatasource
              .getServicesByGroupDescription(tQuery),
        ).thenThrow(tCatalogFailure);
        // act
        final result = await repository.getServicesByGroupDescription(tQuery);
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
          () => mockServiceCatalogDatasource
              .getServicesByGroupDescription(tQuery),
        ).thenThrow(tException);
        when(() => mockErrorHandler.reportException(tException, any()))
            .thenAnswer((_) async {});
        // act
        final result = await repository.getServicesByGroupDescription(tQuery);
        // assert
        verify(() => mockErrorHandler.reportException(tException, any()))
            .called(1);
        expect(result.exceptionOrNull(), isA<UnknownError>());
      },
    );
  });
}
