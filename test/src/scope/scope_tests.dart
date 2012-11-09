part of databinder_test;

class MockModelObservers extends Mock implements ModelObservers {
}

testScope() {
  group("scope", () {
    Scope scope;

    setUp(() {
      scope = new Scope();
      scope.modelObservers = new MockModelObservers();
    });

    test("calls the callback till all observable properties stabilize", () {
      scope.modelObservers.when(callsTo('dirtyCheck')).thenReturn(true, 9);
      scope.modelObservers.when(callsTo('dirtyCheck')).thenReturn(false, 1);

      scope.digest();
    });

    test("raises an exception after 10 iterations", () {
      scope.modelObservers.when(callsTo('dirtyCheck')).thenReturn(true, 10);

      expect(() => scope.digest(), throws);
    });
  });
}

