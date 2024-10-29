import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel.dart';

abstract class CodeCheckPluginPlatform extends PlatformInterface {
  /// Constructs a CodeCheckPluginPlatform.
  CodeCheckPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static CodeCheckPluginPlatform _instance = MethodChannelCodeCheckPlugin();

  /// The default instance of [CodeCheckPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelCodeCheckPlugin].
  static CodeCheckPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CodeCheckPluginPlatform] when
  /// they register themselves.
  static set instance(CodeCheckPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
