import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'chat_composer_method_channel.dart';

abstract class ChatComposerPlatform extends PlatformInterface {
  /// Constructs a ChatComposerPlatform.
  ChatComposerPlatform() : super(token: _token);

  static final Object _token = Object();

  static ChatComposerPlatform _instance = MethodChannelChatComposer();

  /// The default instance of [ChatComposerPlatform] to use.
  ///
  /// Defaults to [MethodChannelChatComposer].
  static ChatComposerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ChatComposerPlatform] when
  /// they register themselves.
  static set instance(ChatComposerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
