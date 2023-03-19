import 'package:cpedidos_pmp/features/catalog/domain/entities/service.dart';
import 'package:cpedidos_pmp/features/catalog/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/catalog/domain/repositories/service_catalog_repository.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_services_by_group_description.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../mocks.dart';

void main() {
  late IServiceCatalogRepository mockServiceCatalogRepository;
  late GetServicesByGroupDescriptionImpl usecase;

  setUp(() {
    mockServiceCatalogRepository = MockServiceCatalogRepository();
    usecase = GetServicesByGroupDescriptionImpl(mockServiceCatalogRepository);
  });

  final tCatalogFailure = MockCatalogFailure();
  const tQuery = 'query';
  const tService = Service(
    code: 'code',
    description: 'description',
    groupCode: 'groupCode',
    groupDescription: 'groupDescription',
  );
  const tServiceList = [tService];

  test(
    'should return a Service list if any service exists.',
    () async {
      // arrange
      when(
        () => mockServiceCatalogRepository.getServicesByGroupDescription(
          tQuery,
        ),
      ).thenAnswer((_) async => const Success(tServiceList));
      // act
      final result = await usecase(tQuery);
      // assert
      expect(result.getOrNull(), equals(tServiceList));
    },
  );

  test(
    'should return a Service empty list if no one service exists.',
    () async {
      // arrange
      when(
        () => mockServiceCatalogRepository.getServicesByGroupDescription(
          tQuery,
        ),
      ).thenAnswer((_) async => const Success([]));
      // act
      final result = await usecase(tQuery);
      // assert
      expect(result.getOrNull(), isA<List<Service>>());
      expect(result.getOrNull(), equals([]));
    },
  );

  test(
    'should return an InvalidInput failure when code param is empty.',
    () async {
      // act
      final result = await usecase('');
      // assert
      expect(result.exceptionOrNull(), isA<InvalidInput>());
    },
  );

  test(
    'should return a failure when repository returns a failure.',
    () async {
      // arrange
      when(
        () => mockServiceCatalogRepository.getServicesByGroupDescription(
          tQuery,
        ),
      ).thenAnswer((_) async => Failure(tCatalogFailure));
      // act
      final result = await usecase(tQuery);
      // assert
      expect(result.exceptionOrNull(), equals(tCatalogFailure));
    },
  );
}
