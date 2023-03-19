import 'package:cpedidos_pmp/core/helpers/debounce.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

void main() {
  late Callable mockCallable;

  setUp(() {
    mockCallable = MockCallable();
  });

  group('debounce', () {
    test(
      'should debounce a function by 500ms, calling only one time.',
      () async {
        // arrange
        final debouncedCallable = debounce(mockCallable, 500);
        // act
        debouncedCallable();
        await Future.delayed(const Duration(milliseconds: 490));
        debouncedCallable();
        await Future.delayed(const Duration(milliseconds: 500));
        // assert
        verify(() => mockCallable()).called(1);
      },
    );
  });

  group('debounce1', () {
    test(
      'should debounce a function with one param by 500ms, calling only one '
      'time.',
      () async {
        // arrange
        final debouncedCallable = debounce1(mockCallable, 500);
        // act
        debouncedCallable(1);
        await Future.delayed(const Duration(milliseconds: 490));
        debouncedCallable(1);
        await Future.delayed(const Duration(milliseconds: 500));
        // assert
        verify(() => mockCallable(1)).called(1);
      },
    );
  });

  group('debounce2', () {
    test(
      'should debounce a function with two param by 500ms, calling only one '
      'time.',
      () async {
        // arrange
        final debouncedCallable = debounce2(mockCallable, 500);
        // act
        debouncedCallable(1, 2);
        await Future.delayed(const Duration(milliseconds: 490));
        debouncedCallable(1, 2);
        await Future.delayed(const Duration(milliseconds: 500));
        // assert
        verify(() => mockCallable(1, 2)).called(1);
      },
    );
  });

  group('debounce3', () {
    test(
      'should debounce a function with three param by 500ms, calling only one '
      'time.',
      () async {
        // arrange
        final debouncedCallable = debounce3(mockCallable, 500);
        // act
        debouncedCallable(1, 2, 3);
        await Future.delayed(const Duration(milliseconds: 490));
        debouncedCallable(1, 2, 3);
        await Future.delayed(const Duration(milliseconds: 500));
        // assert
        verify(() => mockCallable(1, 2, 3)).called(1);
      },
    );
  });
}
