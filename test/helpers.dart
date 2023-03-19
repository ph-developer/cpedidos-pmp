import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart';
import 'package:mocktail/mocktail.dart' as mocktail;

import './mocks.dart';

class MobxTester {
  final caller = MockCallable();
  List<ReactionDisposer> reactionDisposers = [];
  List<Function()> verifications = [];

  void addReaction(String name, dynamic Function() fn) {
    reactionDisposers.add(reaction((_) => fn(), (val) => caller(name, val)));
  }

  void addVerification(String name, dynamic value) {
    verifications.add(() => caller(name, value));
  }

  List<mocktail.VerificationResult> verifyInOrder() {
    return mocktail.verifyInOrder(verifications);
  }
}

extension FinderExt on Finder {
  T getAncestor<T extends Widget>() {
    final widget = find.ancestor(of: this, matching: find.bySubtype<T>());
    return widget.evaluate().first.widget as T;
  }

  T getDescendant<T extends Widget>() {
    final widget = find.descendant(of: this, matching: find.bySubtype<T>());
    return widget.evaluate().first.widget as T;
  }
}
