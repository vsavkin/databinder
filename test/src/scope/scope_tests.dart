part of databinder_test;

class MockModelObservers extends Mock implements ModelObservers {
}

class MockScope extends Mock implements Scope {
}

testScope() {
  group("scope", () {
    Scope scope;

    group("digesting", () {
      setUp(() {
        scope = new Scope();
        scope.modelObservers = new MockModelObservers();
      });

      test("calls the callback till all observable properties stabilize", () {
        scope.modelObservers.when(callsTo('dirtyCheck')).thenReturn(true, 9);
        scope.modelObservers.when(callsTo('dirtyCheck')).thenReturn(false, 1);

        scope.digest();
      });

      test("calls dirtyCheck on children", () {
        var mockScope = new MockScope();
        scope.children = [mockScope];

        scope.modelObservers.when(callsTo('dirtyCheck')).thenReturn(false, 2);
        mockScope.when(callsTo('dirtyCheck')).thenReturn(true);
        mockScope.when(callsTo('dirtyCheck')).thenReturn(false);

        scope.digest();
      });

      test("raises an exception after 10 iterations", () {
        scope.modelObservers.when(callsTo('dirtyCheck')).thenReturn(true, 10);

        expect(() => scope.digest(), throws);
      });
    });

    group("createChild", () {
      setUp(() {
        scope = new Scope();
      });

      test("has no observers", () {
        var child = scope.createChild();
        expect(child.domObservers.isEmpty, isTrue);
        expect(child.modelObservers.isEmpty, isTrue);
      });
    });
  });
}