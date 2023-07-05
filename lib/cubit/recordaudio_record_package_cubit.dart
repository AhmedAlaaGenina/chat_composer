// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';
// import 'package:bloc/bloc.dart';
// import 'package:chat_composer/cubit/recordaudio_cubit.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_sound_lite/flutter_sound.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:record/record.dart';
// import 'package:path/path.dart' as p;
// part 'recordaudio_state.dart';
//
// class RecordAudioCubit extends Cubit<RecordaudioState> {
//   int _recordDuration = 0;
//   Timer? _timer;
//   // late final AudioRecorder _audioRecorder;
//   StreamSubscription<RecordState>? _recordSub;
//   RecordState _recordState = RecordState.stop;
//   StreamSubscription<Amplitude>? _amplitudeSub;
//   Amplitude? _amplitude;
//
//   late final AudioRecorder _audioRecorder;
//   // final FlutterSoundRecorder _myRecorder = FlutterSoundRecorder();
//   final Function()? onRecordStart;
//   final Function(String?) onRecordEnd;
//   final Function()? onRecordCancel;
//   Duration? maxRecordLength;
//
//   ValueNotifier<Duration?> currentDuration = ValueNotifier(Duration.zero);
//   late StreamSubscription? recorderStream;
//
//   RecordAudioCubit({
//     required this.onRecordEnd,
//     required this.onRecordStart,
//     required this.onRecordCancel,
//     required this.maxRecordLength,
//   }) : super(RecordAudioReady()) {
//     // _myRecorder.openAudioSession().then((value) {
//     //   _myRecorder.setSubscriptionDuration(const Duration(milliseconds: 200));
//     _audioRecorder = AudioRecorder();
//
//     _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
//       _updateRecordState(recordState);
//     });
//
//     _amplitudeSub = _audioRecorder
//         .onAmplitudeChanged(const Duration(milliseconds: 300))
//         .listen((amp) {
//       // setState(() => _amplitude = amp);
//       _amplitude = amp;
//       emit(RecordAudioReady());
//     });
//     // recorderStream = _myRecorder.onProgress!.listen((event) {
//     //   Duration current = event.duration;
//     //   currentDuration.value = current;
//     //   if (maxRecordLength != null) {
//     //     if (current.inMilliseconds >= maxRecordLength!.inMilliseconds) {
//     //       log('[chat_composer] 🔴 Audio passed max length');
//     //       stopRecord();
//     //     }
//     //   }
//     // });
//     // });
//   }
//
//   void _startTimer() {
//     _timer?.cancel();
//
//     _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
//       // setState(() => _recordDuration++);
//       _recordDuration++;
//       emit(RecordAudioStarted());
//     });
//   }
//
//   void _updateRecordState(RecordState recordState) {
//     // setState(() => _recordState = recordState);
//     _recordState = recordState;
//     emit(RecordAudioUpdateState());
//
//     switch (recordState) {
//       case RecordState.pause:
//         _timer?.cancel();
//         break;
//       case RecordState.record:
//         _startTimer();
//         break;
//       case RecordState.stop:
//         _timer?.cancel();
//         _recordDuration = 0;
//         break;
//     }
//   }
//
//   void toggleRecord({required bool canRecord}) {
//     emit(canRecord ? RecordAudioReady() : RecordAudioClosed());
//   }
//
//   Future<void> startRecorder() async {
//     try {
//       if (await _audioRecorder.hasPermission()) {
//         const encoder = AudioEncoder.opus;
//
//         // We don't do anything with this but printing
//         final isSupported = await _audioRecorder.isEncoderSupported(
//           encoder,
//         );
//
//         debugPrint('${encoder.name} supported: $isSupported');
//
//         final devs = await _audioRecorder.listInputDevices();
//         debugPrint(devs.toString());
//
//         const config = RecordConfig(encoder: encoder, numChannels: 1);
//
//         // Record to file
//         String path;
//         if (kIsWeb) {
//           path = '';
//         } else {
//           final dir = await getApplicationDocumentsDirectory();
//           path = p.join(
//             dir.path,
//             'audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
//           );
//         }
//         await _audioRecorder.start(config, path: path);
//
//         // Record to stream
//         // final file = File(path);
//         // final stream = await _audioRecorder.startStream(config);
//         // stream.listen(
//         //   (data) {
//         //     // ignore: avoid_print
//         //     print(
//         //       _audioRecorder.convertBytesToInt16(Uint8List.fromList(data)),
//         //     );
//         //     file.writeAsBytesSync(data, mode: FileMode.append);
//         //   },
//         //   // ignore: avoid_print
//         //   onDone: () => print('End of stream'),
//         // );
//
//         _recordDuration = 0;
//
//         _startTimer();
//       }
//     } catch (e) {
//       if (kDebugMode) {
//         print(e);
//       }
//     }
//   }
//
//   Future<void> stopRecord() async {
//     final path = await _audioRecorder.stop();
//
//     if (path != null) {
//       // widget.onStop(path);
//     }
//   }
//
//   Future<void> cancelRecord() async {
//     _audioRecorder.stop();
//   }
//
//   Future<void> pauseRecord() => _audioRecorder.pause();
//
//   Future<void> resumeRecord() => _audioRecorder.resume();
//
//   // void startRecord() async {
//   //   try {
//   //     _myRecorder.stopRecorder();
//   //   } catch (e) {
//   //     //ignore
//   //   }
//   //   currentDuration.value = Duration.zero;
//   //   try {
//   //     var result = await Permission.storage.request();
//   //     print('Result = $result');
//   //     bool hasStorage = await Permission.storage.isGranted;
//   //     print('has Storage = $hasStorage');
//   //     bool hasMic = await Permission.microphone.isGranted;
//   //     print('has Mic = $hasMic');
//   //     if (!hasStorage || !hasMic) {
//   //       if (!hasStorage) await Permission.storage.request();
//   //       if (!hasMic) await Permission.microphone.request();
//   //       log('[chat_composer] 🔴 Denied permissions');
//   //       return;
//   //     }
//   //     if (onRecordStart != null) onRecordStart!();
//   //
//   //     Directory dir = await getApplicationDocumentsDirectory();
//   //     String path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
//   //
//   //     await _myRecorder.startRecorder(
//   //       toFile: path,
//   //       codec: Codec.aacADTS,
//   //     );
//   //
//   //     emit(RecordAudioStarted());
//   //   } catch (e) {
//   //     emit(RecordAudioReady());
//   //   }
//   // }
//   //
//   // void stopRecord() async {
//   //   // timer.cancel();
//   //   try {
//   //     String? result = await _myRecorder.stopRecorder();
//   //     if (result != null) {
//   //       log('[chat_composer] 🟢 Audio path:  "$result');
//   //       onRecordEnd(result);
//   //     }
//   //   } finally {
//   //     currentDuration.value = Duration.zero;
//   //   }
//   //   emit(RecordAudioReady());
//   // }
//   //
//   // void cancelRecord() async {
//   //   try {
//   //     _myRecorder.stopRecorder();
//   //   } catch (ignore) {
//   //     //ignore
//   //   }
//   //   emit(RecordAudioReady());
//   //   if (onRecordCancel != null) onRecordCancel!();
//   //   currentDuration.value = Duration.zero;
//   // }
//   //
//   // @override
//   // Future<void> close() {
//   //   try {
//   //     _myRecorder.closeAudioSession();
//   //   } catch (e) {
//   //     //ignore
//   //   }
//   //   if (recorderStream != null) recorderStream!.cancel();
//   //   try {
//   //     // _myRecorder = null;
//   //     // timer.cancel();
//   //   } catch (e) {
//   //     //ignore
//   //   }
//   //   return super.close();
//   // }
// }
