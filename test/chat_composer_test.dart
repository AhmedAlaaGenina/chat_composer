// import 'package:flutter_test/flutter_test.dart';
// import 'package:chat_composer/chat_composer.dart';
// import 'package:chat_composer/chat_composer_platform_interface.dart';
// import 'package:chat_composer/chat_composer_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockChatComposerPlatform
//     with MockPlatformInterfaceMixin
//     implements ChatComposerPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final ChatComposerPlatform initialPlatform = ChatComposerPlatform.instance;
//
//   test('$MethodChannelChatComposer is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelChatComposer>());
//   });
//
//   test('getPlatformVersion', () async {
//     ChatComposer chatComposerPlugin = ChatComposer();
//     MockChatComposerPlatform fakePlatform = MockChatComposerPlatform();
//     ChatComposerPlatform.instance = fakePlatform;
//
//     expect(await chatComposerPlugin.getPlatformVersion(), '42');
//   });
// }
