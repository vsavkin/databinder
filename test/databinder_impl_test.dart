library databinder_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:databinder/databinder_impl.dart';

import 'package:web_components/watcher.dart';
import 'dart:html';

part 'src/one_way_data_binding_tests.dart';
part 'src/two_way_data_binding_tests.dart';
part 'src/action_binders_tests.dart';
part 'src/utils.dart';

main(){
  useHtmlEnhancedConfiguration();

  testOneWayDataBinding();
  testTwoWayDataBinding();
  testActionBinders();
}