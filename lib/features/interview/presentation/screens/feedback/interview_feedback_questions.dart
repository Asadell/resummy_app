import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';

@RoutePage()
class InterviewFeedbackQuestionsScreen extends StatefulWidget {
  const InterviewFeedbackQuestionsScreen({super.key});

  @override
  State<InterviewFeedbackQuestionsScreen> createState() => _InterviewFeedbackQuestionsScreenState();
}

class _InterviewFeedbackQuestionsScreenState extends State<InterviewFeedbackQuestionsScreen> {
  int _expandedIndex = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'title': 'Pertanyaan 1: Project challenging',
      'score': 8.5,
      'color': AppColors.secondary,
      'preview': 'Anda menjelaskan situasi dengan jelas tentang memimpin project MVP...',
      'breakdown': {
        'STAR': 8.5,
        'Lancar': 6.0,
        'Konten': 7.5,
        'Confidence': 7.0,
      }
    },
    {
      'title': 'Pertanyaan 2: Memimpin tim',
      'score': 7.8,
      'color': AppColors.primary,
      'preview': 'Good explanation tentang leadership dalam kondisi pressure...',
      'breakdown': {
        'STAR': 8.0,
        'Lancar': 7.0,
        'Konten': 8.0,
        'Confidence': 8.0,
      }
    },
    {
      'title': 'Pertanyaan 3: Handle konflik',
      'score': 6.5,
      'color': AppColors.warning,
      'preview': 'Situasi dijelaskan tapi perlu lebih spesifik pada resolution...',
      'breakdown': {
        'STAR': 6.0,
        'Lancar': 6.5,
        'Konten': 7.0,
        'Confidence': 6.5,
      }
    },
    {
      'title': 'Pertanyaan 4: Kegagalan dipelajari',
      'score': 7.2,
      'color': AppColors.primary,
      'preview': 'Strong reflection dan learning points, tapi bisa tambah impact...',
      'breakdown': {
        'STAR': 7.5,
        'Lancar': 7.0,
        'Konten': 7.0,
        'Confidence': 7.2,
      }
    },
    {
      'title': 'Pertanyaan 5: Kenapa kerja di sini',
      'score': 7.0,
      'color': AppColors.primary,
      'preview': 'Research tentang company baik, tapi STAR structure lemah...',
      'breakdown': {
        'STAR': 6.0,
        'Lancar': 7.5,
        'Konten': 7.5,
        'Confidence': 7.0,
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('📋 ${l10n.fullReport}'),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_1),
          onPressed: () => context.router.push(const InterviewFeedbackOverviewRoute()),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Summary Header
            Container(
              padding: const EdgeInsets.all(20),
              color: Theme.of(context).cardTheme.color,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.clipboard_text, color: Theme.of(context).textTheme.headlineMedium?.color),
                      const SizedBox(width: 8),
                      Text(
                        l10n.fullReportTitle,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '5 ${l10n.questions} | ${l10n.overallScore}: 7.5',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Question Cards
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  final question = _questions[index];
                  final isExpanded = _expandedIndex == index;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(12),
                      border: Border(
                        left: BorderSide(
                          color: question['color'] as Color,
                          width: 4,
                        ),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _expandedIndex = isExpanded ? -1 : index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              children: [
                                Icon(
                                  isExpanded ? Iconsax.arrow_up_2 : Iconsax.arrow_down_2,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    question['title'] as String,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: question['color'] as Color,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${question['score']}/10',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Mini Scores
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: (question['breakdown'] as Map<String, double>)
                                    .entries
                                    .map((entry) {
                                  Color chipColor = AppColors.primary;
                                  if (entry.value >= 8.0) {
                                    chipColor = AppColors.secondary;
                                  } else if (entry.value < 7.0) {
                                    chipColor = AppColors.warning;
                                  }
                                  
                                  return Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: chipColor,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      '${entry.key}: ${entry.value}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 12), // Added SizedBox for spacing
                            Row(
                              children: [
                                Icon(Iconsax.tick_circle, color: Theme.of(context).colorScheme.secondary),
                                const SizedBox(width: 8),
                                const Text('Strong Points:'),
                              ],
                            ),
                            if (isExpanded) ...[
                              const SizedBox(height: 12),
                              Text(
                                question['preview'] as String,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () => context.router.push(const InterviewFeedbackDetailRoute()),
                                  child: Text('${l10n.viewDetail} →'),
                                ),
                              ),
                            ] else ...[
                              const SizedBox(height: 8),
                              Text(
                                question['preview'] as String,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
                    color: Theme.of(context).brightness == Brightness.light ? Colors.black.withValues(alpha: 0.05) : Colors.transparent,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Iconsax.document_download),
             label: Text(l10n.downloadPdf),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
          ),
        ),
      ),
    );
  }
}