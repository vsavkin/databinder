# DataBinder

Data binding is a technique used to maintain synchronization of data. It's a key component of most MVP/MVVM frameworks. DataBinder is a Dart library that uses object mirrors to implement data binding. Though the primary focus of the library to be used for building MV* frameworks, it can be used directly.

## Core principles

#### Do all bindings dynamically => no compilation

The compilation approch is a good solution in many situations, but I strongly believe that binding in runtime is more advantageous.

* No extra steps in the build process
* Easier to understand
* Templates can be build dynamically or retrieved from a database

#### Follow the MDV syntax as close as possible

#### Provide extension points for frameworks

To be a good foundation for bulding MV* frameworks Databinder should allow to plug in custom binders and customize parsing.

## How to use it

### Add the databinder dependency to your pubspec.yaml

	name:  sampleapp
	dependencies:
	  databinder:
	    git: https://github.com/vsavkin/databinder

### Define a view model

	class Person {
	  String firstName, lastName;

	  Person(this.firstName, this.lastName);

	  toUpperCase(e){
	    firstName = firstName.toUpperCase();
	    lastName = lastName.toUpperCase();
	  }

	  toLowerCase(e){
	    firstName = firstName.toLowerCase();
	    lastName = lastName.toLowerCase();
	  }
	}


### Just 3 methods

* bind - registers model and DOM watchers
* unbind - unregisters all the registred watchers
* notify - triggers all the registered model watchers

### One-way data-binding

	<fieldset id="one-way">
	  First name {{firstName}}
	  Last name {{lastName}}
	</fieldset>

To bind:

	var person = new Person("Jim", "Smith");
	var element = query("#one-way");
	var binder = new DataBinder(element, person);
	binder.bind();

To unbind:

	binder.unbind();

### Two-way data-binding

	<fieldset id="two-way-form">
	  First name <input data-bind="value:firstName"/>
	  Last name <input data-bind="value:lastName"/>
	</fieldset>

To bind:

	var person = new Person("Jim", "Smith");
	var element = query("#two-way-form");
	var binder = new DataBinder(element, person);
	binder.bind();

To unbind:

	binder.unbind();

### Binding actions

	<div id="actions">
	  <button data-action="click:toUpperCase">TO UPPER CASE</button>
	  <button data-action="click:toLowerCase">to lower case</button>
	</div>

To bind:
	
	var person = new Person("Jim", "Smith");
	var element = query("#actions");
	var binder = new DataBinder(element, person);
	binder.bind();

To unbind:
	
	binder.unbind();

## Example app

Check out the example application that comes with the package to see the library in action.

## Current status

At this point, the library is more than just a spike, but not yet ready for production. 

The things I'm going to work on next:

* There are only integration tests at this point. Having more unit tests will be helpful.
* Two-way data-bindindg works only with the input element. Other elements need to be supported as well.
* At this point, you can only bind to the source object's getter. It requires some work, so the following binding will work as well: "data-bind='user.address.street.name'".
* The implementation is naive when it comes to listening for DOM events. 

Though it's very early days and so much stuff needs to be done, the library is already useful.