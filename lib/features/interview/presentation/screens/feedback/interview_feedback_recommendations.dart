import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';

@RoutePage()
class InterviewFeedbackRecommendationsScreen extends StatelessWidget {
  const InterviewFeedbackRecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<InterviewProvider>(
      builder: (context, provider, child) {
        final report = provider.report;
        if (report == null) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Iconsax.arrow_left_2),
              onPressed: () => context.router.push(const InterviewFeedbackOverviewRoute()),
            ),
            title: Row(
              children: [
                Icon(Iconsax.lamp_on, color: Theme.of(context).colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(l10n.recommendations),
              ],
            ),
             actions: [
                IconButton(
                  icon: const Icon(Iconsax.document_download),
                  onPressed: () {},
                ),
              ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Row(
                    children: [
                      Icon(Iconsax.lamp_on, color: Theme.of(context).colorScheme.primary, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        l10n.recommendations,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.basedOnPerformance,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Strengths Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                      border: const Border(
                        left: BorderSide(color: AppColors.secondary, width: 4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Iconsax.weight, color: Theme.of(context).colorScheme.secondary, size: 32),
                        const SizedBox(height: 12),
                        Text(
                          l10n.yourStrengths,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (report.strengths.isEmpty)
                          Text('No specific strengths identified.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))
                        else
                          ...report.strengths.map((s) => Column(
                            children: [
                              _buildListItem(context, '✓ $s', Theme.of(context).colorScheme.onSurface),
                              const SizedBox(height: 10),
                            ],
                          )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Improvements Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                      border: const Border(
                        left: BorderSide(color: AppColors.warning, width: 4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Iconsax.direct_up, color: Theme.of(context).colorScheme.error, size: 32),
                        const SizedBox(height: 12),
                        Text(
                          l10n.areasForImprovement,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (report.improvements.isEmpty)
                           Text('No specific improvements identified.', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))
                        else
                          ...report.improvements.map((s) => Column(
                            children: [
                              _buildListItem(context, '⚠️ $s', Theme.of(context).colorScheme.onSurface),
                              const SizedBox(height: 10),
                            ],
                          )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Readiness Assessment (Simplified based on score)
                  _buildReadinessCard(context, report.overallScore, l10n),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                        provider.resetInterview();
                        context.router.push(const InterviewPrepRoute());
                    },
                    icon: const Icon(Iconsax.refresh),
                    label: Text(l10n.practiceAgain), // 'Practice Again'
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                    ),
                  ),
                  const SizedBox(height: 12),
                   // Dashboard button
                   OutlinedButton.icon(
                    onPressed: () => context.router.push(const InterviewPrepRoute()), // Or HomeRoute
                    icon: const Icon(Icons.home),
                    label: Text(l10n.dashboard),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.gray600,
                      side: const BorderSide(color: AppColors.gray300),
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListItem(BuildContext context, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadinessCard(BuildContext context, int score, AppLocalizations l10n) {
      Color bgColor;
      String title;
      String message;
      IconData icon;

      if (score >= 80) {
          bgColor = AppColors.secondary; // Green
          title = l10n.readinessStatusExcellent;
          message = l10n.readinessDescExcellent;
          icon = Iconsax.tick_circle;
      } else if (score >= 60) {
          bgColor = Colors.orange;
          title = l10n.readinessStatusGood;
          message = l10n.readinessDescGood;
          icon = Iconsax.timer_1;
      } else {
          bgColor = AppColors.error;
          title = l10n.readinessStatusNeedsWork;
          message = l10n.readinessDescNeedsWork;
          icon = Iconsax.close_circle;
      }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}