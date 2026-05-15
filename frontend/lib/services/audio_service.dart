import 'package:audioplayers/audioplayers.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AudioService {
  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();
  bool _isRecorderInitialized = false;

  Future<bool> checkPermissions() async {
    final hasPermission = await _audioRecorder.hasPermission();
    _isRecorderInitialized = hasPermission;
    return hasPermission;
  }

  Future<void> startRecording() async {
    if (!_isRecorderInitialized) {
      final granted = await checkPermissions();
      if (!granted) {
        throw Exception('Microphone permission denied');
      }
    }

    String path = '';
    if (!kIsWeb) {
      final directory = await getApplicationDocumentsDirectory();
      path = '${directory.path}/symptom_audio.wav';
    }

    await _audioRecorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 16000,
        numChannels: 1,
      ),
      path: path,
    );
  }

  Future<String?> stopRecording() async {
    return await _audioRecorder.stop();
  }

  Future<void> playAudio(String path, {bool isLocal = false}) async {
    if (isLocal) {
      await _audioPlayer.play(DeviceFileSource(path));
    } else {
      await _audioPlayer.play(UrlSource(path));
    }
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }

  bool get isPlaying {
    return _audioPlayer.state == PlayerState.playing;
  }

  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
  }
}
