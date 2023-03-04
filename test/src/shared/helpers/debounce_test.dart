import 'package:cpedidos_pmp/src/shared/helpers/debounce.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks.dart';

void main() {
  late Callable mockCallable;

  setUp(() {
    mockCallable = MockCallable();
  });

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
}
