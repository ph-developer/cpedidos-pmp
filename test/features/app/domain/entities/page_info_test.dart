import 'package:cpedidos_pmp/features/app/domain/entities/page_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'should return true when all props are equals.',
    () async {
      // arrange
      const tPageInfoA = PageInfo(
        description: 'description',
        path: 'path',
        icon: Icons.abc,
      );
      const tPageInfoB = PageInfo(
        description: 'description',
        path: 'path',
        icon: Icons.abc,
      );
      // act
      final result = tPageInfoA == tPageInfoB;
      // assert
      expect(result, isTrue);
    },
  );

  test(
    'should return false when any prop are different.',
    () async {
      // arrange
      const tPageInfoA = PageInfo(
        description: 'description',
        path: 'path1',
        icon: Icons.abc,
      );
      const tPageInfoB = PageInfo(
        description: 'description',
        path: 'path2',
        icon: Icons.abc,
      );
      // act
      final result = tPageInfoA == tPageInfoB;
      // assert
      expect(result, isFalse);
    },
  );
}
