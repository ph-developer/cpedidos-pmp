import 'package:cpedidos_pmp/features/catalog/external/models/catmat_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tCatmatMap = {
    'extraction_date': 'extractionDate',
    'groups': {'groupCode': 'groupDescription'},
    'items': {
      'itemCode': ['groupCode', 'itemDescription']
    },
  };
  const tCatmat = CatmatModel(
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
      const tCatmatA = CatmatModel(
        extractionDate: 'extractionDate',
        groups: {'groupCode': 'groupDescription'},
        items: {
          'itemCode': ['groupCode', 'itemDescription']
        },
      );
      const tCatmatB = CatmatModel(
        extractionDate: 'extractionDate',
        groups: {'groupCode': 'groupDescription'},
        items: {
          'itemCode': ['groupCode', 'itemDescription']
        },
      );
      // act
      final result = tCatmatA == tCatmatB;
      // assert
      expect(result, isTrue);
    },
  );

  test(
    'should return false when any prop are different.',
    () async {
      // arrange
      const tCatmatA = CatmatModel(
        extractionDate: 'extractionDate1',
        groups: {'groupCode': 'groupDescription'},
        items: {
          'itemCode': ['groupCode', 'itemDescription']
        },
      );
      const tCatmatB = CatmatModel(
        extractionDate: 'extractionDate2',
        groups: {'groupCode': 'groupDescription'},
        items: {
          'itemCode': ['groupCode', 'itemDescription']
        },
      );
      // act
      final result = tCatmatA == tCatmatB;
      // assert
      expect(result, isFalse);
    },
  );

  group('fromMap', () {
    test(
      'should convert a map to a CatmatModel.',
      () async {
        // act
        final result = CatmatModel.fromMap(tCatmatMap);
        // assert
        expect(result, isA<CatmatModel>());
        expect(result, equals(tCatmat));
      },
    );
  });
}
