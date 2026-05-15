class AnalysisResult {
  final String speechText;
  final Map<String, dynamic> visionAnalysis;
  final String aiAnalysis;
  final String risk;
  final String voiceOutput;
  final String referralPdf;

  AnalysisResult({
    required this.speechText,
    required this.visionAnalysis,
    required this.aiAnalysis,
    required this.risk,
    required this.voiceOutput,
    required this.referralPdf,
  });

  factory AnalysisResult.fromJson(Map<String, dynamic> json) {
    return AnalysisResult(
      speechText: json['speech_text'] ?? '',
      visionAnalysis: json['vision_analysis'] is Map
          ? Map<String, dynamic>.from(json['vision_analysis'])
          : {},
      aiAnalysis: json['ai_analysis'] ?? '',
      risk: json['risk'] ?? 'UNKNOWN',
      voiceOutput: json['voice_output'] ?? '',
      referralPdf: json['referral_pdf'] ?? '',
    );
  }

  /// Whether the risk level is an emergency
  bool get isEmergency => risk.toUpperCase() == 'EMERGENCY';

  /// Whether the risk level is high
  bool get isHighRisk => risk.toUpperCase() == 'HIGH RISK';

  /// Whether the risk level is low
  bool get isLowRisk => risk.toUpperCase() == 'LOW RISK';
}
