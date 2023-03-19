import 'dart:convert';

import 'package:cpedidos_pmp/features/catalog/domain/entities/service.dart';
import 'package:cpedidos_pmp/features/catalog/domain/errors/failures.dart';
import 'package:cpedidos_pmp/features/catalog/external/datasources/service_catalog_datasource_impl.dart';
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
  const tService = Service(
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

  late ServiceCatalogDatasourceImpl datasource;

  setUp(() {
    datasource = ServiceCatalogDatasourceImpl();
  });

  group('getServiceByCode', () {
    test(
      'should return a Service when an item with code exists.',
      () async {
        // act
        final result = await datasource.getServiceByCode(tCode);
        // assert
        expect(result, equals(tService));
      },
    );

    test(
      'should throws an ServiceNotFound failure when not exists an item with '
      'code.',
      () async {
        // act
        final future = datasource.getServiceByCode('not_exists');
        // assert
        expect(future, throwsA(isA<ServiceNotFound>()));
      },
    );
  });

  group('getServicesByDescription', () {
    test(
      'should return a Service list when at least one item that contains a '
      'description query exists.',
      () async {
        // arrange
        const tQuery = 't_mDe%tio';
        // act
        final result = await datasource.getServicesByDescription(tQuery);
        // assert
        expect(result, equals([tService]));
      },
    );

    test(
      'should return a Service empty list when no one item that contains a '
      'description query exists.',
      () async {
        // arrange
        const tQuery = 't_meDe%tio';
        // act
        final result = await datasource.getServicesByDescription(tQuery);
        // assert
        expect(result, isA<List<Service>>());
        expect(result, equals([]));
      },
    );
  });

  group('getServicesByGroupDescription', () {
    test(
      'should return a Service list when at least one item that group contains'
      ' a description query exists.',
      () async {
        // arrange
        const tQuery = 'o_pDe%tio';
        // act
        final result = await datasource.getServicesByGroupDescription(tQuery);
        // assert
        expect(result, equals([tService]));
      },
    );

    test(
      'should return a Service empty list when no one item that group contains'
      ' a description query exists.',
      () async {
        // arrange
        const tQuery = 'o_peDe%tio';
        // act
        final result = await datasource.getServicesByGroupDescription(tQuery);
        // assert
        expect(result, isA<List<Service>>());
        expect(result, equals([]));
      },
    );
  });
}
