import 'package:cpedidos_pmp/features/catalog/domain/entities/service.dart';
import 'package:cpedidos_pmp/features/catalog/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/catalog/domain/repositories/service_catalog_repository.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_service_by_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../mocks.dart';

void main() {
  late IServiceCatalogRepository mockServiceCatalogRepository;
  late GetServiceByCodeImpl usecase;

  setUp(() {
    mockServiceCatalogRepository = MockServiceCatalogRepository();
    usecase = GetServiceByCodeImpl(mockServiceCatalogRepository);
  });

  final tCatalogFailure = MockCatalogFailure();
  const tCode = 'code';
  const tService = Service(
    code: 'code',
    description: 'description',
    groupCode: 'groupCode',
    groupDescription: 'groupDescription',
  );

  test(
    'should return a Service if exists.',
    () async {
      // arrange
      when(() => mockServiceCatalogRepository.getServiceByCode(tCode))
          .thenAnswer((_) async => const Success(tService));
      // act
      final result = await usecase(tCode);
      // assert
      expect(result.getOrNull(), equals(tService));
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
      when(() => mockServiceCatalogRepository.getServiceByCode(tCode))
          .thenAnswer((_) async => Failure(tCatalogFailure));
      // act
      final result = await usecase(tCode);
      // assert
      expect(result.exceptionOrNull(), equals(tCatalogFailure));
    },
  );
}
