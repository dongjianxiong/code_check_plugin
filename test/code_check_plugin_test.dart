import 'package:code_check_plugin/code_check_plugin.dart';
import 'package:code_check_plugin/method_channel.dart';
import 'package:code_check_plugin/platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCodeCheckPluginPlatform
    with MockPlatformInterfaceMixin
    implements CodeCheckPluginPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CodeCheckPluginPlatform initialPlatform = CodeCheckPluginPlatform.instance;

  test('$MethodChannelCodeCheckPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCodeCheckPlugin>());
  });

  test('getPlatformVersion', () async {
    CodeCheckPlugin codeCheckPlugin = CodeCheckPlugin();
    MockCodeCheckPluginPlatform fakePlatform = MockCodeCheckPluginPlatform();
    CodeCheckPluginPlatform.instance = fakePlatform;

    expect(await codeCheckPlugin.getPlatformVersion(), '42');
  });
}
