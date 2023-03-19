import 'package:cpedidos_pmp/core/reactivity/obs_paginated_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tList = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  late ObservablePaginatedList obs;

  group('of', () {
    test(
      'should init with 10 entries.',
      () async {
        // act
        obs = ObservablePaginatedList.of(tList);
        // assert
        expect(obs.all.length, equals(10));
      },
    );

    test(
      'should init with 5 max items by page.',
      () async {
        // act
        obs = ObservablePaginatedList.of(tList, 5);
        // assert
        expect(obs.paginated.length, 5);
      },
    );
  });

  group('all', () {
    test(
      'should return the entire list.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of(tList, 5);
        // act
        final result = obs.all;
        // assert
        expect(result, equals(tList));
      },
    );
  });

  group('paginated', () {
    test(
      'should return the five firsts elements of list.',
      () async {
        // arrange
        final fiveFirstsElements = tList.take(5);
        obs = ObservablePaginatedList.of(tList, 5);
        // act
        final result = obs.paginated;
        // assert
        expect(result, equals(fiveFirstsElements));
      },
    );

    test(
      'should return the five lasts elements of list.',
      () async {
        // arrange
        final fiveLastsElements = tList.skip(5).take(5);
        obs = ObservablePaginatedList.of(tList, 5)..nextPage();
        // act
        final result = obs.paginated;
        // assert
        expect(result, equals(fiveLastsElements));
      },
    );
  });

  group('currentPage', () {
    test(
      'should return 1 when current page is 1.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of(tList, 5);
        // act
        final result = obs.currentPage;
        // assert
        expect(result, equals(1));
      },
    );

    test(
      'should return 2 when current page is 2.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of(tList, 5)..nextPage();
        // act
        final result = obs.currentPage;
        // assert
        expect(result, equals(2));
      },
    );
  });

  group('pagesCount', () {
    test(
      'should return 1 when have only one page.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of(tList, 10);
        // act
        final result = obs.pagesCount;
        // assert
        expect(result, equals(1));
      },
    );

    test(
      'should return 5 when have five pages.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of(tList, 2);
        // act
        final result = obs.pagesCount;
        // assert
        expect(result, equals(5));
      },
    );
  });

  group('length', () {
    test(
      'should return the list length.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of(tList);
        // act
        final result = obs.length;
        // assert
        expect(result, tList.length);
      },
    );
  });

  group('isEmpty', () {
    test(
      'should return true when list is empty.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of([]);
        // act
        final result = obs.isEmpty;
        // assert
        expect(result, isTrue);
      },
    );

    test(
      'should return false when list is not empty.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of(tList);
        // act
        final result = obs.isEmpty;
        // assert
        expect(result, isFalse);
      },
    );
  });

  group('isNotEmpty', () {
    test(
      'should return true when list is not empty.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of(tList);
        // act
        final result = obs.isNotEmpty;
        // assert
        expect(result, isTrue);
      },
    );

    test(
      'should return false when list is empty.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of([]);
        // act
        final result = obs.isNotEmpty;
        // assert
        expect(result, isFalse);
      },
    );
  });

  group('setMaxItemsByPage', () {
    test(
      'should change max items by page.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of(tList, 5);
        expect(obs.pagesCount, 2);
        // act
        obs.setMaxItemsByPage(2);
        // assert
        expect(obs.pagesCount, 5);
      },
    );

    test(
      'should change max items by page and change current page to last page '
      'when new last page is lesser than old one.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of(tList, 2)
          ..nextPage()
          ..nextPage()
          ..nextPage()
          ..nextPage();
        expect(obs.pagesCount, 5);

        // act
        obs.setMaxItemsByPage(5);
        // assert
        expect(obs.pagesCount, 2);
        expect(obs.currentPage, 2);
      },
    );
  });

  group('previousPage', () {
    test(
      'should back one page when current page is greater than 1.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of(tList, 5)
          ..nextPage()
          // act
          ..previousPage();
        // assert
        expect(obs.currentPage, equals(1));
      },
    );

    test(
      'should not back one page when current page is 1.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of(tList, 5)
          // act
          ..previousPage();
        // assert
        expect(obs.currentPage, equals(1));
      },
    );
  });

  group('nextPage', () {
    test(
      'should advance one page when current page is lesser than pages count.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of(tList, 5)
          // act
          ..nextPage();
        // assert
        expect(obs.currentPage, equals(2));
      },
    );

    test(
      'should not advance one page when current page is equal pages count.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of(tList, 5)
          ..nextPage()
          // act
          ..nextPage();
        // assert
        expect(obs.currentPage, equals(2));
      },
    );
  });

  group('addAll', () {
    test(
      'should add elements to list.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of(tList)
          // act
          ..addAll(tList);
        // assert
        expect(obs.all, equals([...tList, ...tList]));
      },
    );
  });

  group('clear', () {
    test(
      'should clear list and set current page to 1.',
      () async {
        // arrange
        obs = ObservablePaginatedList.of(tList, 5)
          ..nextPage()
          // act
          ..clear();
        // assert
        expect(obs.length, equals(0));
        expect(obs.currentPage, equals(1));
      },
    );
  });
}
