import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/analysis_result.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator, localhost for web/desktop
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000';
    }
    return 'http://localhost:8000';
  }

  Future<AnalysisResult> analyzeSymptoms(
      String audioPath, String imagePath) async {
    final uri = Uri.parse('$baseUrl/analyze');
    final request = http.MultipartRequest('POST', uri);

    if (kIsWeb) {
      // On web, paths are actually blob URLs
      final audioResponse = await http.get(Uri.parse(audioPath));
      final imageResponse = await http.get(Uri.parse(imagePath));
      
      request.files.add(http.MultipartFile.fromBytes('audio', audioResponse.bodyBytes, filename: 'audio.wav'));
      request.files.add(http.MultipartFile.fromBytes('image', imageResponse.bodyBytes, filename: 'image.jpg'));
    } else {
      request.files.add(await http.MultipartFile.fromPath('audio', audioPath));
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
    }

    try {
      final response = await request.send().timeout(
        const Duration(seconds: 300),
      );

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final decodedData = json.decode(responseData);
        return AnalysisResult.fromJson(decodedData);
      } else {
        final body = await response.stream.bytesToString();
        String? errorMessage;
        try {
          final errorJson = json.decode(body);
          if (errorJson['detail'] != null) {
            errorMessage = errorJson['detail'];
          }
        } catch (_) {}
        
        if (errorMessage != null) {
          throw Exception(errorMessage);
        }
        throw Exception('Analysis failed (${response.statusCode}): $body');
      }
    } on TimeoutException {
      throw Exception('Analysis timed out. The AI took too long to process. Please ensure your inputs are clear and try again.');
    }
  }

  Future<List<int>> downloadFile(String path) async {
    final uri = Uri.parse('$baseUrl/$path');
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to download file (${response.statusCode})');
    }
  }

  /// Check if backend is reachable
  Future<bool> healthCheck() async {
    try {
      final uri = Uri.parse('$baseUrl/');
      final response = await http.get(uri).timeout(
        const Duration(seconds: 5),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
