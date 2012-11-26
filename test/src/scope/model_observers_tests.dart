part of databinder_test;

class EventCapturer {
  var event;

  callback(e) => event = e;
  clear() => event = null;
  bool get isCalled => event != null;
}

class Observable {
  int property = 0;
}

testObservers() {
  group("observers", () {

    group("simple values", (){
      ModelObservers observers;
      EventCapturer eventCapturer;
      Observable observable;

      setUp((){
        observers = new ModelObservers(new Scope());
        eventCapturer = new EventCapturer();
        observable = new Observable();
      });

      test("registers simple observers", (){  
        observers.register(()=> observable.property, eventCapturer.callback);
        expect(observers.registeredObservers.length, equals(1));
      });

      test("calls the observer on register", (){
        observers.register(()=> observable.property, eventCapturer.callback);
        expect(eventCapturer.isCalled, isTrue);
      });

      test("calls the callback when the value changes", (){
        observers.register(()=> observable.property, eventCapturer.callback);

        eventCapturer.clear();

        observable.property += 1;

        observers.dirtyCheck();

        expect(eventCapturer.isCalled, isTrue);
      });

      test("sets the old and new values", (){
        observers.register(()=> observable.property, eventCapturer.callback);

        observable.property += 1;

        observers.dirtyCheck();

        expect(eventCapturer.event.oldValue, equals(0));
        expect(eventCapturer.event.newValue, equals(1));
      });

      test("doesn't call the callback when the value doesn't change", (){
        observers.register(()=> observable.property, eventCapturer.callback);

        eventCapturer.clear();

        observers.dirtyCheck();

        expect(eventCapturer.isCalled, isFalse);
      });
    });

    group("list values", (){
      ModelObservers observers;
      EventCapturer eventCapturer;
      List observable;

      setUp((){
        observers = new ModelObservers(new Scope());
        eventCapturer = new EventCapturer();
        observable = [1,2];
      });

      test("registers list observers", (){
        observers.registerListObserver(()=> observable, eventCapturer.callback);
        expect(observers.registeredObservers.length, equals(1));
      });

      test("calls the observer on register", (){
        observers.registerListObserver(()=> observable, eventCapturer.callback);
        expect(eventCapturer.isCalled, isTrue);
      });

      test("calls the callback when the length of the list changes", (){
        observers.registerListObserver(()=> observable, eventCapturer.callback);

        eventCapturer.clear();

        observable.add(1);

        observers.dirtyCheck();

        expect(eventCapturer.isCalled, isTrue);
      });

      test("calls the callback when an element of the list changes", (){
        observers.registerListObserver(()=> observable, eventCapturer.callback);

        eventCapturer.clear();

        observable[0] = 100;

        observers.dirtyCheck();

        expect(eventCapturer.isCalled, isTrue);
      });

      test("doesn't call the callback when the value doesn't change", (){
        observers.registerListObserver(()=> observable, eventCapturer.callback);

        eventCapturer.clear();

        observers.dirtyCheck();

        expect(eventCapturer.isCalled, isFalse);
      });
    });
  });
}

