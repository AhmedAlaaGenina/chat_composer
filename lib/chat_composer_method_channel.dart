import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'chat_composer_platform_interface.dart';

/// An implementation of [ChatComposerPlatform] that uses method channels.
class MethodChannelChatComposer extends ChatComposerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('chat_composer');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
