import 'package:cpedidos_pmp/features/catalog/domain/entities/material.dart';
import 'package:cpedidos_pmp/features/catalog/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/catalog/domain/repositories/material_catalog_repository.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_materials_by_group_description.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../mocks.dart';

void main() {
  late IMaterialCatalogRepository mockMaterialCatalogRepository;
  late GetMaterialsByGroupDescriptionImpl usecase;

  setUp(() {
    mockMaterialCatalogRepository = MockMaterialCatalogRepository();
    usecase = GetMaterialsByGroupDescriptionImpl(mockMaterialCatalogRepository);
  });

  final tCatalogFailure = MockCatalogFailure();
  const tQuery = 'query';
  const tMaterial = Material(
    code: 'code',
    description: 'description',
    groupCode: 'groupCode',
    groupDescription: 'groupDescription',
  );
  const tMaterialList = [tMaterial];

  test(
    'should return a Material list if any material exists.',
    () async {
      // arrange
      when(
        () => mockMaterialCatalogRepository.getMaterialsByGroupDescription(
          tQuery,
        ),
      ).thenAnswer((_) async => const Success(tMaterialList));
      // act
      final result = await usecase(tQuery);
      // assert
      expect(result.getOrNull(), equals(tMaterialList));
    },
  );

  test(
    'should return a Material empty list if no one material exists.',
    () async {
      // arrange
      when(
        () => mockMaterialCatalogRepository.getMaterialsByGroupDescription(
          tQuery,
        ),
      ).thenAnswer((_) async => const Success([]));
      // act
      final result = await usecase(tQuery);
      // assert
      expect(result.getOrNull(), isA<List<Material>>());
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
        () => mockMaterialCatalogRepository.getMaterialsByGroupDescription(
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
