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
        observers = new ModelObservers();
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

        observers.notify();

        expect(eventCapturer.isCalled, isTrue);
      });

      test("sets the old and new values", (){
        observers.register(()=> observable.property, eventCapturer.callback);

        observable.property += 1;

        observers.notify();

        expect(eventCapturer.event.oldValue, equals(0));
        expect(eventCapturer.event.newValue, equals(1));
      });

      test("doesn't call the callback when the value doesn't change", (){
        observers.register(()=> observable.property, eventCapturer.callback);

        eventCapturer.clear();

        observers.notify();

        expect(eventCapturer.isCalled, isFalse);
      });

      test("calls the callback till all observable properties stabilize", (){
        var numberOfCalls = 0;

        var callback = (e){
          if(observable.property < 5)
            observable.property += 1;

          numberOfCalls += 1;
        };

        observers.register(()=> observable.property, callback);

        observable.property += 1;

        observers.notify();

        expect(observable.property, equals(5));
        expect(numberOfCalls, equals(5));
      });

      test("raises an exception after 10 iterations", (){
        var numberOfCalls = 0;

        var callback = (e){
          observable.property += 1;
          numberOfCalls += 1;
        };

        observers.register(()=> observable.property, callback);

        observable.property += 1;

        expect(()=> observers.notify(), throws);
        expect(numberOfCalls, equals(11));
      });
    });
  });
}

