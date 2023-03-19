import 'package:cpedidos_pmp/features/catalog/domain/entities/material.dart';
import 'package:cpedidos_pmp/features/catalog/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/catalog/domain/repositories/material_catalog_repository.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_material_by_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../mocks.dart';

void main() {
  late IMaterialCatalogRepository mockMaterialCatalogRepository;
  late GetMaterialByCodeImpl usecase;

  setUp(() {
    mockMaterialCatalogRepository = MockMaterialCatalogRepository();
    usecase = GetMaterialByCodeImpl(mockMaterialCatalogRepository);
  });

  final tCatalogFailure = MockCatalogFailure();
  const tCode = 'code';
  const tMaterial = Material(
    code: 'code',
    description: 'description',
    groupCode: 'groupCode',
    groupDescription: 'groupDescription',
  );

  test(
    'should return a Material if exists.',
    () async {
      // arrange
      when(() => mockMaterialCatalogRepository.getMaterialByCode(tCode))
          .thenAnswer((_) async => const Success(tMaterial));
      // act
      final result = await usecase(tCode);
      // assert
      expect(result.getOrNull(), equals(tMaterial));
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
      when(() => mockMaterialCatalogRepository.getMaterialByCode(tCode))
          .thenAnswer((_) async => Failure(tCatalogFailure));
      // act
      final result = await usecase(tCode);
      // assert
      expect(result.exceptionOrNull(), equals(tCatalogFailure));
    },
  );
}
