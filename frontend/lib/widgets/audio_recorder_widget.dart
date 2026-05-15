import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';
import '../theme/app_theme.dart';

class AudioRecorderWidget extends StatefulWidget {
  const AudioRecorderWidget({super.key});

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: AppTheme.premiumCard(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Mic Button
                GestureDetector(
                  onTap: () => provider.toggleRecording(),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Container(
                        padding: EdgeInsets.all(
                          provider.isRecording
                              ? 12.0 + (_pulseAnimation.value * 6.0)
                              : 12.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: provider.isRecording
                              ? AppTheme.emergencyColor.withAlpha(26)
                              : AppTheme.primaryColor.withAlpha(18),
                          boxShadow: provider.isRecording
                              ? [
                                  BoxShadow(
                                    color:
                                        AppTheme.emergencyColor.withAlpha(51),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ]
                              : [],
                        ),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: provider.isRecording
                                ? AppTheme.emergencyGradient
                                : AppTheme.primaryGradient,
                            boxShadow: [
                              BoxShadow(
                                color: (provider.isRecording
                                        ? AppTheme.emergencyColor
                                        : AppTheme.primaryColor)
                                    .withAlpha(77),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            provider.isRecording
                                ? Icons.stop_rounded
                                : Icons.mic_rounded,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Recording indicator
                if (provider.isRecording)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.emergencyColor.withAlpha(18),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.emergencyColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Recording... Tap to stop',
                          style: TextStyle(
                            color: AppTheme.emergencyColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    provider.audioPath != null
                        ? '✅ Audio captured successfully'
                        : 'Tap microphone to describe symptoms',
                    style: TextStyle(
                      color: provider.audioPath != null
                          ? AppTheme.lowRiskColor
                          : Colors.grey[500],
                      fontWeight: provider.audioPath != null
                          ? FontWeight.w600
                          : FontWeight.w400,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
