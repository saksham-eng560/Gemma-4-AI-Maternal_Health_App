import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RiskCard extends StatefulWidget {
  final String riskLevel;

  const RiskCard({super.key, required this.riskLevel});

  @override
  State<RiskCard> createState() => _RiskCardState();
}

class _RiskCardState extends State<RiskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LinearGradient gradient;
    IconData riskIcon;
    String warningText;
    IconData secondaryIcon;

    switch (widget.riskLevel.toUpperCase()) {
      case 'EMERGENCY':
        gradient = AppTheme.emergencyGradient;
        riskIcon = Icons.warning_amber_rounded;
        warningText = 'SEEK IMMEDIATE MEDICAL ATTENTION';
        secondaryIcon = Icons.local_hospital_rounded;
        break;
      case 'HIGH RISK':
        gradient = AppTheme.warningGradient;
        riskIcon = Icons.priority_high_rounded;
        warningText = 'CONSULT A DOCTOR SOON';
        secondaryIcon = Icons.medical_services_rounded;
        break;
      default:
        gradient = AppTheme.safeGradient;
        riskIcon = Icons.check_circle_outline;
        warningText = 'CONTINUE ROUTINE CARE';
        secondaryIcon = Icons.health_and_safety_rounded;
    }

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withAlpha(102),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(secondaryIcon, size: 28, color: Colors.white.withAlpha(150)),
                const SizedBox(width: 12),
                Icon(riskIcon, size: 56, color: Colors.white),
                const SizedBox(width: 12),
                Icon(secondaryIcon, size: 28, color: Colors.white.withAlpha(150)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.riskLevel.toUpperCase(),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(38),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                warningText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
