library databinder_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:databinder/databinder_impl.dart';

import 'dart:html';

part 'src/scope/model_observers_test.dart';
part 'src/scope/scope_test.dart';
part 'src/parser/nodes_tests.dart';
part 'src/one_way_data_binding_tests.dart';
part 'src/two_way_data_binding_tests.dart';
part 'src/action_binders_tests.dart';
part 'src/utils.dart';

main(){
  useHtmlEnhancedConfiguration();

  testObservers();
  testScope();
  testNodes();
  testOneWayDataBinding();
  testTwoWayDataBinding();
  testActionBinders();
}