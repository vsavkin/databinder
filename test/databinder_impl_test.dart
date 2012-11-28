library databinder_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/mock.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:databinder/databinder_impl.dart';

import 'dart:html';

part 'src/utils.dart';

part 'src/scope/model_observers_tests.dart';
part 'src/scope/scope_tests.dart';
part 'src/scope/transformations_tests.dart';
part 'src/scope/bound_objects_spec.dart';

part 'src/parser/nodes_tests.dart';

part 'src/reflection/reflector_tests.dart';

part 'src/binders/one_way_data_binding_tests.dart';
part 'src/binders/two_way_data_binding_tests.dart';
part 'src/binders/action_binders_tests.dart';
part 'src/binders/conditionals_tests.dart';
part 'src/binders/iteration_tests.dart';

main(){
  useHtmlEnhancedConfiguration();

  testObservers();
  testScope();
  testBoundObjects();
  testNodes();
  testTransformations();
  testReflector();
  testOneWayDataBinding();
  testTwoWayDataBinding();
  testActionBinders();
  testConditionals();
  testIteration();
}