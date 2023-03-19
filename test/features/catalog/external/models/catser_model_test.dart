import 'package:cpedidos_pmp/features/catalog/external/models/catser_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tCatserMap = {
    'extraction_date': 'extractionDate',
    'groups': {'groupCode': 'groupDescription'},
    'items': {
      'itemCode': ['groupCode', 'itemDescription']
    },
  };
  const tCatser = CatserModel(
    extractionDate: 'extractionDate',
    groups: {'groupCode': 'groupDescription'},
    items: {
      'itemCode': ['groupCode', 'itemDescription']
    },
  );

  test(
    'should return true when all props are equals.',
    () async {
      // arrange
      const tCatserA = CatserModel(
        extractionDate: 'extractionDate',
        groups: {'groupCode': 'groupDescription'},
        items: {
          'itemCode': ['groupCode', 'itemDescription']
        },
      );
      const tCatserB = CatserModel(
        extractionDate: 'extractionDate',
        groups: {'groupCode': 'groupDescription'},
        items: {
          'itemCode': ['groupCode', 'itemDescription']
        },
      );
      // act
      final result = tCatserA == tCatserB;
      // assert
      expect(result, isTrue);
    },
  );

  test(
    'should return false when any prop are different.',
    () async {
      // arrange
      const tCatserA = CatserModel(
        extractionDate: 'extractionDate1',
        groups: {'groupCode': 'groupDescription'},
        items: {
          'itemCode': ['groupCode', 'itemDescription']
        },
      );
      const tCatserB = CatserModel(
        extractionDate: 'extractionDate2',
        groups: {'groupCode': 'groupDescription'},
        items: {
          'itemCode': ['groupCode', 'itemDescription']
        },
      );
      // act
      final result = tCatserA == tCatserB;
      // assert
      expect(result, isFalse);
    },
  );

  group('fromMap', () {
    test(
      'should convert a map to a CatserModel.',
      () async {
        // act
        final result = CatserModel.fromMap(tCatserMap);
        // assert
        expect(result, isA<CatserModel>());
        expect(result, equals(tCatser));
      },
    );
  });
}
