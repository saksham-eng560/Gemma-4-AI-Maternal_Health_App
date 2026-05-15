import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/risk_card.dart';
import 'referral_screen.dart';
import 'home_screen.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HealthProvider>(
        builder: (context, provider, child) {
          final result = provider.result;
          if (result == null) {
            return const Center(child: Text('No results found.'));
          }

          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                expandedHeight: 60,
                floating: false,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () {
                    provider.resetAll();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (route) => false,
                    );
                  },
                ),
                title: const Text('Analysis Results'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    tooltip: 'New Analysis',
                    onPressed: () {
                      provider.resetAll();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Risk Card
                      RiskCard(riskLevel: result.risk),
                      const SizedBox(height: 24),

                      // Quick Actions
                      _buildQuickActions(context, provider, result),
                      const SizedBox(height: 24),

                      // Speech Transcription
                      _buildResultCard(
                        context,
                        title: 'Voice Transcription',
                        subtitle: 'What the AI heard',
                        content: result.speechText,
                        icon: Icons.hearing_rounded,
                        iconColor: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 16),

                      // AI Analysis
                      _buildResultCard(
                        context,
                        title: 'AI Medical Analysis',
                        subtitle: 'Powered by Gemma AI',
                        content: result.aiAnalysis,
                        icon: Icons.psychology_rounded,
                        iconColor: AppTheme.accentColor,
                      ),
                      const SizedBox(height: 16),

                      // Vision Analysis
                      if (result.visionAnalysis.isNotEmpty)
                        _buildVisionCard(context, result.visionAnalysis),
                      const SizedBox(height: 24),

                      // View Referral Button
                      _buildReferralButton(context),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildQuickActions(
      BuildContext context, HealthProvider provider, dynamic result) {
    return Row(
      children: [
        if (result.voiceOutput != null &&
            result.voiceOutput.toString().isNotEmpty)
          Expanded(
            child: _buildActionChip(
              context,
              icon: provider.isPlayingVoice
                  ? Icons.stop_circle_rounded
                  : Icons.volume_up_rounded,
              label: provider.isPlayingVoice ? 'Playing...' : 'Hindi Audio',
              gradient: AppTheme.primaryGradient,
              onTap: () => provider.playVoiceOutput(),
            ),
          ),
        if (result.voiceOutput != null &&
            result.voiceOutput.toString().isNotEmpty)
          const SizedBox(width: 12),
        Expanded(
          child: _buildActionChip(
            context,
            icon: Icons.picture_as_pdf_rounded,
            label: 'Get PDF',
            gradient: AppTheme.accentGradient,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReferralScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: gradient,
            boxShadow: [
              BoxShadow(
                color: gradient.colors.first.withAlpha(64),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String content,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      decoration: AppTheme.premiumCard(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D2B55),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                content.isEmpty ? 'No data available.' : content,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: Color(0xFF4A4A6A),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisionCard(
      BuildContext context, Map<String, dynamic> visionData) {
    return Container(
      decoration: AppTheme.premiumCard(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.teal.withAlpha(26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.visibility_rounded,
                      color: Colors.teal, size: 20),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Visual Analysis',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D2B55),
                      ),
                    ),
                    Text(
                      'Image scan results',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...visionData.entries.map((entry) {
              final isDetected = entry.value == true;
              final label = entry.key
                  .replaceAll('_', ' ')
                  .split(' ')
                  .map((w) =>
                      w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
                  .join(' ');
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDetected
                      ? AppTheme.emergencyColor.withAlpha(13)
                      : AppTheme.lowRiskColor.withAlpha(13),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDetected
                        ? AppTheme.emergencyColor.withAlpha(38)
                        : AppTheme.lowRiskColor.withAlpha(38),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isDetected
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_outline,
                      color: isDetected
                          ? AppTheme.emergencyColor
                          : AppTheme.lowRiskColor,
                      size: 18,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isDetected
                              ? AppTheme.emergencyColor
                              : AppTheme.lowRiskColor,
                        ),
                      ),
                    ),
                    Text(
                      isDetected ? 'DETECTED' : 'CLEAR',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: isDetected
                            ? AppTheme.emergencyColor
                            : AppTheme.lowRiskColor,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralButton(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withAlpha(64),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReferralScreen()),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.description_rounded,
                  color: AppTheme.primaryColor, size: 20),
              SizedBox(width: 10),
              Text(
                'View Full Referral Document',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
