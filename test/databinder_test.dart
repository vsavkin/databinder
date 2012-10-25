library databinder_test;

import 'package:unittest/unittest.dart';
import 'package:unittest/html_enhanced_config.dart';
import 'package:databinder/databinder.dart';

import 'package:web_components/watcher.dart';
import 'dart:html';

part 'src/one_way_data_binding_tests.dart';
part 'src/two_way_data_binding_tests.dart';
part 'src/action_listener_tests.dart';
part 'src/utils.dart';

main(){
  useHtmlEnhancedConfiguration();

  testOneWayDataBinding();
  testTwoWayDataBinding();
  testActionListener();
}