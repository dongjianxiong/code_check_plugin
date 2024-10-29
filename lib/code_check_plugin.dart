import 'package:code_check_plugin/platform_interface.dart';

class CodeCheckPlugin {
  int? _a;

  Future<String?> getPlatformVersion() {
    return CodeCheckPluginPlatform.instance.getPlatformVersion();
  }
}
