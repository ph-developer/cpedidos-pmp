import 'package:cpedidos_pmp/features/catalog/domain/entities/item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'should return true when all props are equals.',
    () async {
      // arrange
      const tItemA = Item(
        code: 'code',
        description: 'description',
        groupCode: 'groupCode',
        groupDescription: 'groupDescription',
      );
      const tItemB = Item(
        code: 'code',
        description: 'description',
        groupCode: 'groupCode',
        groupDescription: 'groupDescription',
      );
      // act
      final result = tItemA == tItemB;
      // assert
      expect(result, isTrue);
    },
  );

  test(
    'should return false when any prop are different.',
    () async {
      // arrange
      const tItemA = Item(
        code: 'code1',
        description: 'description',
        groupCode: 'groupCode',
        groupDescription: 'groupDescription',
      );
      const tItemB = Item(
        code: 'code2',
        description: 'description',
        groupCode: 'groupCode',
        groupDescription: 'groupDescription',
      );
      // act
      final result = tItemA == tItemB;
      // assert
      expect(result, isFalse);
    },
  );
}
