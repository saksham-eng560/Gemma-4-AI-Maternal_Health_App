import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../theme/app_theme.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  int _currentStep = 0;

  final List<_LoadingStep> _steps = [
    _LoadingStep(Icons.upload_file, 'Uploading files...'),
    _LoadingStep(Icons.mic, 'Transcribing audio...'),
    _LoadingStep(Icons.remove_red_eye, 'Analyzing image...'),
    _LoadingStep(Icons.psychology, 'Running AI diagnosis...'),
    _LoadingStep(Icons.assessment, 'Evaluating risk level...'),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Animate through steps
    _animateSteps();
  }

  void _animateSteps() async {
    for (int i = 0; i < _steps.length; i++) {
      await Future.delayed(const Duration(milliseconds: 2500));
      if (mounted) {
        setState(() => _currentStep = i);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.splashGradient,
          ),
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pulsing heart
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: const SpinKitPumpingHeart(
                          color: Colors.white,
                          size: 100.0,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 48),

                  // Title
                  const Text(
                    'Analyzing Your Symptoms',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'AI Models Running Locally',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withAlpha(153),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Step indicators
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: List.generate(_steps.length, (index) {
                        final isActive = index == _currentStep;
                        final isDone = index < _currentStep;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isActive
                                ? Colors.white.withAlpha(38)
                                : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isDone
                                    ? Icons.check_circle
                                    : _steps[index].icon,
                                color: isActive
                                    ? Colors.white
                                    : isDone
                                        ? AppTheme.lowRiskColor
                                        : Colors.white.withAlpha(64),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _steps[index].label,
                                style: TextStyle(
                                  color: isActive
                                      ? Colors.white
                                      : isDone
                                          ? AppTheme.lowRiskColor
                                          : Colors.white.withAlpha(64),
                                  fontSize: 14,
                                  fontWeight: isActive
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                ),
                              ),
                              if (isActive) ...[
                                const Spacer(),
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white.withAlpha(179),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingStep {
  final IconData icon;
  final String label;
  const _LoadingStep(this.icon, this.label);
}
