import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/analysis_result.dart';
import '../services/api_service.dart';
import '../services/audio_service.dart';
import '../services/file_service.dart';

enum AppState { idle, recording, analyzing, results, error }

class HealthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AudioService _audioService = AudioService();
  final FileService _fileService = FileService();
  final ImagePicker _picker = ImagePicker();

  String? _imagePath;
  String? get imagePath => _imagePath;

  String? _audioPath;
  String? get audioPath => _audioPath;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPlayingVoice = false;
  bool get isPlayingVoice => _isPlayingVoice;

  AppState _appState = AppState.idle;
  AppState get appState => _appState;

  AnalysisResult? _result;
  AnalysisResult? get result => _result;

  String? _error;
  String? get error => _error;

  String _statusMessage = '';
  String get statusMessage => _statusMessage;

  bool get isReadyToAnalyze =>
      _imagePath != null && _audioPath != null && !_isLoading;

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (image != null) {
        _imagePath = image.path;
        _error = null;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Failed to pick image: $e';
      notifyListeners();
    }
  }

  Future<void> toggleRecording() async {
    try {
      if (_isRecording) {
        _audioPath = await _audioService.stopRecording();
        _isRecording = false;
        _statusMessage = 'Audio recorded successfully';
      } else {
        await _audioService.startRecording();
        _isRecording = true;
        _statusMessage = 'Recording...';
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _isRecording = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> analyze() async {
    if (_imagePath == null || _audioPath == null) {
      _error = 'Please provide both an image and voice recording.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    _appState = AppState.analyzing;
    _statusMessage = 'Connecting to AI server...';
    notifyListeners();

    try {
      // Check backend health first
      _statusMessage = 'Checking server connection...';
      notifyListeners();

      final isHealthy = await _apiService.healthCheck();
      if (!isHealthy) {
        throw Exception(
            'Cannot connect to backend server. Make sure the FastAPI server is running on port 8000.');
      }

      _statusMessage = 'Uploading files & running AI analysis...';
      notifyListeners();

      _result = await _apiService.analyzeSymptoms(_audioPath!, _imagePath!);
      _isLoading = false;
      _appState = AppState.results;
      _statusMessage = 'Analysis complete!';
      notifyListeners();

      // Auto-play audio if EMERGENCY
      if (_result?.isEmergency == true && _result!.voiceOutput.isNotEmpty) {
        playVoiceOutput();
      }
      return true;
    } catch (e) {
      _isLoading = false;
      _appState = AppState.error;
      _error = e.toString().replaceAll('Exception: ', '');
      _statusMessage = '';
      notifyListeners();
      return false;
    }
  }

  Future<void> playVoiceOutput() async {
    if (_result?.voiceOutput != null && _result!.voiceOutput.isNotEmpty) {
      try {
        _isPlayingVoice = true;
        notifyListeners();

        final url = '${ApiService.baseUrl}/${_result!.voiceOutput}';
        await _audioService.playAudio(url);

        // Wait a bit and reset
        await Future.delayed(const Duration(seconds: 5));
        _isPlayingVoice = false;
        notifyListeners();
      } catch (e) {
        _isPlayingVoice = false;
        _error = 'Failed to play audio: $e';
        notifyListeners();
      }
    }
  }

  Future<void> downloadAndOpenPdf() async {
    if (_result?.referralPdf != null && _result!.referralPdf.isNotEmpty) {
      try {
        _statusMessage = 'Opening PDF...';
        notifyListeners();

        if (kIsWeb) {
          final url = Uri.parse('${ApiService.baseUrl}/${_result!.referralPdf}');
          if (!await launchUrl(url)) {
            throw Exception('Could not launch PDF URL');
          }
        } else {
          final bytes = await _apiService.downloadFile(_result!.referralPdf);
          final filename = _result!.referralPdf.split('/').last;
          final localPath = await _fileService.saveLocally(bytes, filename);
          await _fileService.openSavedFile(localPath);
        }

        _statusMessage = '';
        notifyListeners();
      } catch (e) {
        _error = 'Failed to open PDF: $e';
        _statusMessage = '';
        notifyListeners();
      }
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void resetAll() {
    _imagePath = null;
    _audioPath = null;
    _isRecording = false;
    _isLoading = false;
    _isPlayingVoice = false;
    _result = null;
    _error = null;
    _statusMessage = '';
    _appState = AppState.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
