library databinder_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:databinder/databinder_impl.dart';

import 'dart:html';

part 'src/observers/model_observers_test.dart';
part 'src/one_way_data_binding_tests.dart';
part 'src/two_way_data_binding_tests.dart';
part 'src/action_binders_tests.dart';
part 'src/utils.dart';

main(){
  useHtmlEnhancedConfiguration();

  testObservers();
  testOneWayDataBinding();
  testTwoWayDataBinding();
  testActionBinders();
}