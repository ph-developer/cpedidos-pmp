import 'package:cpedidos_pmp/core/reactivity/obs_paginated_list.dart';
import 'package:cpedidos_pmp/features/catalog/domain/entities/material.dart';
import 'package:cpedidos_pmp/features/catalog/domain/entities/service.dart';
import 'package:cpedidos_pmp/features/catalog/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_material_by_code.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_materials_by_description.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_materials_by_group_description.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_service_by_code.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_services_by_description.dart';
import 'package:cpedidos_pmp/features/catalog/domain/usecases/get_services_by_group_description.dart';
import 'package:cpedidos_pmp/features/catalog/presentation/controllers/items_search_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

import '../../../../mocks.dart';

void main() {
  late IGetMaterialByCode mockGetMaterialByCode;
  late IGetMaterialsByDescription mockGetMaterialsByDescription;
  late IGetMaterialsByGroupDescription mockGetMaterialsByGroupDescription;
  late IGetServiceByCode mockGetServiceByCode;
  late IGetServicesByDescription mockGetServicesByDescription;
  late IGetServicesByGroupDescription mockGetServicesByGroupDescription;
  late ItemsSearchController controller;

  setUp(() {
    mockGetMaterialByCode = MockGetMaterialByCode();
    mockGetMaterialsByDescription = MockGetMaterialsByDescription();
    mockGetMaterialsByGroupDescription = MockGetMaterialsByGroupDescription();
    mockGetServiceByCode = MockGetServiceByCode();
    mockGetServicesByDescription = MockGetServicesByDescription();
    mockGetServicesByGroupDescription = MockGetServicesByGroupDescription();
    controller = ItemsSearchController(
      mockGetMaterialByCode,
      mockGetMaterialsByDescription,
      mockGetMaterialsByGroupDescription,
      mockGetServiceByCode,
      mockGetServicesByDescription,
      mockGetServicesByGroupDescription,
    )..toString();
  });

  const tQuery = 'query';
  const tMaterial = Material(
    code: 'code',
    description: 'description',
    groupCode: 'groupCode',
    groupDescription: 'groupDescription',
  );
  const tMaterialList = [tMaterial];
  const tService = Service(
    code: 'code',
    description: 'description',
    groupCode: 'groupCode',
    groupDescription: 'groupDescription',
  );
  const tServiceList = [tService];
  final tFailure = MockCatalogFailure();

  group('clearSearch', () {
    test(
      'should clear loaded items and set loaded as false.',
      () async {
        // arrange
        controller
          ..loadedItems = ObservablePaginatedList.of(tMaterialList)
          ..isLoaded = true;
        expect(controller.loadedItems.length, tMaterialList.length);
        expect(controller.isLoaded, isTrue);
        // act
        await controller.clearSearch();
        // assert
        expect(controller.loadedItems.length, equals(0));
        expect(controller.isLoaded, isFalse);
      },
    );
  });

  group('searchItems', () {
    group('when itemType is "material"', () {
      group('and searchType is "code"', () {
        test(
          'should set loaded items if some item is found.',
          () async {
            // arrange
            when(() => mockGetMaterialByCode(tQuery))
                .thenAnswer((_) async => const Success(tMaterial));
            // act
            await controller.searchItems({
              'itemType': 'material',
              'searchType': 'code',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals(tMaterialList));
            expect(controller.isLoaded, isTrue);
          },
        );

        test(
          'should set empty loaded items if no one item is found.',
          () async {
            // arrange
            when(() => mockGetMaterialByCode(tQuery))
                .thenAnswer((_) async => const Failure(MaterialNotFound()));
            // act
            await controller.searchItems({
              'itemType': 'material',
              'searchType': 'code',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals([]));
            expect(controller.isLoaded, isTrue);
          },
        );

        test(
          'should set failure when usecase returns a failure.',
          () async {
            // arrange
            when(() => mockGetMaterialByCode(tQuery))
                .thenAnswer((_) async => Failure(tFailure));
            // act
            await controller.searchItems({
              'itemType': 'material',
              'searchType': 'code',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals([]));
            expect(controller.isLoaded, isTrue);
            expect(controller.failure, equals(tFailure));
          },
        );
      });

      group('and searchType is "description"', () {
        test(
          'should set loaded items if some item is found.',
          () async {
            // arrange
            when(() => mockGetMaterialsByDescription(tQuery))
                .thenAnswer((_) async => const Success(tMaterialList));
            // act
            await controller.searchItems({
              'itemType': 'material',
              'searchType': 'description',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals(tMaterialList));
            expect(controller.isLoaded, isTrue);
          },
        );

        test(
          'should set empty loaded items if no one item is found.',
          () async {
            // arrange
            when(() => mockGetMaterialsByDescription(tQuery))
                .thenAnswer((_) async => const Success([]));
            // act
            await controller.searchItems({
              'itemType': 'material',
              'searchType': 'description',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals([]));
            expect(controller.isLoaded, isTrue);
          },
        );

        test(
          'should set failure when usecase returns a failure.',
          () async {
            // arrange
            when(() => mockGetMaterialsByDescription(tQuery))
                .thenAnswer((_) async => Failure(tFailure));
            // act
            await controller.searchItems({
              'itemType': 'material',
              'searchType': 'description',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals([]));
            expect(controller.isLoaded, isTrue);
            expect(controller.failure, equals(tFailure));
          },
        );
      });

      group('and searchType is "groupDescription"', () {
        test(
          'should set loaded items if some item is found.',
          () async {
            // arrange
            when(() => mockGetMaterialsByGroupDescription(tQuery))
                .thenAnswer((_) async => const Success(tMaterialList));
            // act
            await controller.searchItems({
              'itemType': 'material',
              'searchType': 'groupDescription',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals(tMaterialList));
            expect(controller.isLoaded, isTrue);
          },
        );

        test(
          'should set empty loaded items if no one item is found.',
          () async {
            // arrange
            when(() => mockGetMaterialsByGroupDescription(tQuery))
                .thenAnswer((_) async => const Success([]));
            // act
            await controller.searchItems({
              'itemType': 'material',
              'searchType': 'groupDescription',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals([]));
            expect(controller.isLoaded, isTrue);
          },
        );

        test(
          'should set failure when usecase returns a failure.',
          () async {
            // arrange
            when(() => mockGetMaterialsByGroupDescription(tQuery))
                .thenAnswer((_) async => Failure(tFailure));
            // act
            await controller.searchItems({
              'itemType': 'material',
              'searchType': 'groupDescription',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals([]));
            expect(controller.isLoaded, isTrue);
            expect(controller.failure, equals(tFailure));
          },
        );
      });
    });

    group('when itemType is "service"', () {
      group('and searchType is "code"', () {
        test(
          'should set loaded items if some item is found.',
          () async {
            // arrange
            when(() => mockGetServiceByCode(tQuery))
                .thenAnswer((_) async => const Success(tService));
            // act
            await controller.searchItems({
              'itemType': 'service',
              'searchType': 'code',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals(tServiceList));
            expect(controller.isLoaded, isTrue);
          },
        );

        test(
          'should set empty loaded items if no one item is found.',
          () async {
            // arrange
            when(() => mockGetServiceByCode(tQuery))
                .thenAnswer((_) async => const Failure(MaterialNotFound()));
            // act
            await controller.searchItems({
              'itemType': 'service',
              'searchType': 'code',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals([]));
            expect(controller.isLoaded, isTrue);
          },
        );

        test(
          'should set failure when usecase returns a failure.',
          () async {
            // arrange
            when(() => mockGetServiceByCode(tQuery))
                .thenAnswer((_) async => Failure(tFailure));
            // act
            await controller.searchItems({
              'itemType': 'service',
              'searchType': 'code',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals([]));
            expect(controller.isLoaded, isTrue);
            expect(controller.failure, equals(tFailure));
          },
        );
      });

      group('and searchType is "description"', () {
        test(
          'should set loaded items if some item is found.',
          () async {
            // arrange
            when(() => mockGetServicesByDescription(tQuery))
                .thenAnswer((_) async => const Success(tServiceList));
            // act
            await controller.searchItems({
              'itemType': 'service',
              'searchType': 'description',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals(tServiceList));
            expect(controller.isLoaded, isTrue);
          },
        );

        test(
          'should set empty loaded items if no one item is found.',
          () async {
            // arrange
            when(() => mockGetServicesByDescription(tQuery))
                .thenAnswer((_) async => const Success([]));
            // act
            await controller.searchItems({
              'itemType': 'service',
              'searchType': 'description',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals([]));
            expect(controller.isLoaded, isTrue);
          },
        );

        test(
          'should set failure when usecase returns a failure.',
          () async {
            // arrange
            when(() => mockGetServicesByDescription(tQuery))
                .thenAnswer((_) async => Failure(tFailure));
            // act
            await controller.searchItems({
              'itemType': 'service',
              'searchType': 'description',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals([]));
            expect(controller.isLoaded, isTrue);
            expect(controller.failure, equals(tFailure));
          },
        );
      });

      group('and searchType is "groupDescription"', () {
        test(
          'should set loaded items if some item is found.',
          () async {
            // arrange
            when(() => mockGetServicesByGroupDescription(tQuery))
                .thenAnswer((_) async => const Success(tServiceList));
            // act
            await controller.searchItems({
              'itemType': 'service',
              'searchType': 'groupDescription',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals(tServiceList));
            expect(controller.isLoaded, isTrue);
          },
        );

        test(
          'should set empty loaded items if no one item is found.',
          () async {
            // arrange
            when(() => mockGetServicesByGroupDescription(tQuery))
                .thenAnswer((_) async => const Success([]));
            // act
            await controller.searchItems({
              'itemType': 'service',
              'searchType': 'groupDescription',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals([]));
            expect(controller.isLoaded, isTrue);
          },
        );

        test(
          'should set failure when usecase returns a failure.',
          () async {
            // arrange
            when(() => mockGetServicesByGroupDescription(tQuery))
                .thenAnswer((_) async => Failure(tFailure));
            // act
            await controller.searchItems({
              'itemType': 'service',
              'searchType': 'groupDescription',
              'query': tQuery,
            });
            // assert
            expect(controller.loadedItems.all, equals([]));
            expect(controller.isLoaded, isTrue);
            expect(controller.failure, equals(tFailure));
          },
        );
      });
    });
  });
}
