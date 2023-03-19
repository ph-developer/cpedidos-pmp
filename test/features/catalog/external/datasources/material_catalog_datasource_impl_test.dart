import 'dart:convert';

import 'package:cpedidos_pmp/features/catalog/domain/entities/material.dart';
import 'package:cpedidos_pmp/features/catalog/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/catalog/external/datasources/material_catalog_datasource_impl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const tCode = 'itemCode';
  final tCatmatMap = {
    'extraction_date': 'extractionDate',
    'groups': {'groupCode': 'groupDescription'},
    'items': {
      tCode: ['groupCode', 'itemDescription']
    },
  };
  const tMaterial = Material(
    code: tCode,
    description: 'itemDescription',
    groupCode: 'groupCode',
    groupDescription: 'groupDescription',
  );
  ServicesBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
    'flutter/assets',
    (_) async {
      final tCatmatString = jsonEncode(tCatmatMap);
      return utf8.encoder.convert(tCatmatString).buffer.asByteData();
    },
  );

  late MaterialCatalogDatasourceImpl datasource;

  setUp(() {
    datasource = MaterialCatalogDatasourceImpl();
  });

  group('getMaterialByCode', () {
    test(
      'should return a Material when an item with code exists.',
      () async {
        // act
        final result = await datasource.getMaterialByCode(tCode);
        // assert
        expect(result, equals(tMaterial));
      },
    );

    test(
      'should throws an MaterialNotFound failure when not exists an item with '
      'code.',
      () async {
        // act
        final future = datasource.getMaterialByCode('not_exists');
        // assert
        expect(future, throwsA(isA<MaterialNotFound>()));
      },
    );
  });

  group('getMaterialsByDescription', () {
    test(
      'should return a Material list when at least one item that contains a '
      'description query exists.',
      () async {
        // arrange
        const tQuery = 't_mDe%tio';
        // act
        final result = await datasource.getMaterialsByDescription(tQuery);
        // assert
        expect(result, equals([tMaterial]));
      },
    );

    test(
      'should return a Material empty list when no one item that contains a '
      'description query exists.',
      () async {
        // arrange
        const tQuery = 't_meDe%tio';
        // act
        final result = await datasource.getMaterialsByDescription(tQuery);
        // assert
        expect(result, isA<List<Material>>());
        expect(result, equals([]));
      },
    );
  });

  group('getMaterialsByGroupDescription', () {
    test(
      'should return a Material list when at least one item that group contains'
      ' a description query exists.',
      () async {
        // arrange
        const tQuery = 'o_pDe%tio';
        // act
        final result = await datasource.getMaterialsByGroupDescription(tQuery);
        // assert
        expect(result, equals([tMaterial]));
      },
    );

    test(
      'should return a Material empty list when no one item that group contains'
      ' a description query exists.',
      () async {
        // arrange
        const tQuery = 'o_peDe%tio';
        // act
        final result = await datasource.getMaterialsByGroupDescription(tQuery);
        // assert
        expect(result, isA<List<Material>>());
        expect(result, equals([]));
      },
    );
  });
}
