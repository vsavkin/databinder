part of databinder_test;

class FakeBoundObjects implements BoundObjects {
  var obj;

  FakeBoundObjects(this.obj);

  match(selector){
    return new BoundObjectMatch(obj, selector);
  }
}


testReflector() {
  group("reflector", () {
    group("createProperyHandle", (){
      Reflector reflector;
      Person person;
      FakeBoundObjects boundObjects;

      setUp((){
        reflector = new Reflector();
        person = new Person(name: "value");
        person.address = new Address("street");

        boundObjects = new FakeBoundObjects(person);
      });

      test("creates a handle with a getter", () {
        var handle = reflector.createPropertyHandle(boundObjects, "name");
        expect(handle.getter(), equals("value"));
      });

      test("creates a handle with a setter", () {
        var handle = reflector.createPropertyHandle(boundObjects, "name");
        handle.setter("new value");
        expect(person.name, equals("new value"));
      });

      test("supports complex path expressions", (){
        var handle = reflector.createPropertyHandle(boundObjects, "address.street");
        expect(handle.getter(), equals("street"));
      });
    });

    group("createCallback", (){
      Reflector reflector;
      Person person;
      FakeBoundObjects boundObjects;

      setUp((){
        reflector = new Reflector();
        person = new Person(age: 10);
        boundObjects = new FakeBoundObjects(person);
      });

      test("creates a callback", () {
        var callback = reflector.createCallback(boundObjects, "doubleAge");
        callback(null);
        expect(person.age, equals(20));
      });

      test("supports complex path expressions", (){
        person.address = new Address("street");

        var handle = reflector.createCallback(boundObjects, "address.uppercase");
        handle(null);
        expect(person.address.street, equals("STREET"));
      });

      test("throws an exception when invalid method name", (){
        var callback = reflector.createCallback(boundObjects, "invalid");
        expect(() => callback(null), throwsA(new isInstanceOf<DataBinderException>()));
      });

      test("throws an exception when invalid path", (){
        person.address = new Address("street");

        var callback = reflector.createCallback(boundObjects, "address.invalid");
        expect(() => callback(null), throwsA(new isInstanceOf<DataBinderException>()));
      });

      test("throws an exception when receiver is null", (){
        person.address = new Address("street");

        var callback = reflector.createCallback(boundObjects, "address.invalid");
        expect(() => callback(null), throwsA(new isInstanceOf<DataBinderException>()));
      });

      test("throws an exception when malformed path", (){
        person.address = new Address("street");

        var callback = reflector.createCallback(boundObjects, ".\asf.sfj.");
        expect(() => callback(null), throwsA(new isInstanceOf<DataBinderException>()));
      });
    });
  });
}

