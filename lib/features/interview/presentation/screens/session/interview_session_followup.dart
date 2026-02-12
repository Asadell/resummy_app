import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';

@RoutePage()
class InterviewSessionFollowupScreen extends StatefulWidget {
  const InterviewSessionFollowupScreen({super.key});

  @override
  State<InterviewSessionFollowupScreen> createState() => _InterviewSessionFollowupScreenState();
}

class _InterviewSessionFollowupScreenState extends State<InterviewSessionFollowupScreen> {
  bool _showTranscript = true;
  bool _showFullAnswer = false;

  Future<void> _showExitDialog() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar Interview?'),
        content: const Text('Progress akan hilang jika keluar sekarang.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Lanjut Interview'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ya, Keluar'),
          ),
        ],
      ),
    ) ?? false;

    if (shouldExit && mounted) {
      context.router.push(const InterviewPrepRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Iconsax.close_circle, color: Theme.of(context).colorScheme.error),
          onPressed: _showExitDialog,
        ),
        title: const Text('Question 1 (Follow-up)'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Row(
                children: [
                  Icon(Iconsax.timer_1, size: 16, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    '03:45',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Toggle Control
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    'Toggle Teks:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  _buildToggleButton(true, 'ON 🟢'),
                  const SizedBox(width: 8),
                  _buildToggleButton(false, 'OFF ⚪'),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Previous Answer Summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        border: Border.all(color: Theme.of(context).dividerTheme.color!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Iconsax.document_text, color: Theme.of(context).colorScheme.primary, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Jawaban Anda:',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Anda memimpin project MVP dengan tim 3 orang dalam deadline ketat...',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            maxLines: _showFullAnswer ? null : 2,
                            overflow: _showFullAnswer ? null : TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => setState(() => _showFullAnswer = !_showFullAnswer),
                            child: Text(
                              _showFullAnswer ? 'Sembunyikan ▲' : 'Lihat full answer ▼',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Follow-up Question Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(16),
                        border: Border(
                          left: BorderSide(color: Theme.of(context).colorScheme.secondary, width: 4),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Iconsax.refresh, color: Theme.of(context).colorScheme.secondary, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  'Follow-up Question',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Iconsax.profile_circle, color: Theme.of(context).colorScheme.primary, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'AI Interviewer:',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Menarik! Bisa ceritakan lebih detail tentang challenge spesifik yang Anda hadapi dan bagaimana Anda prioritas task?',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Hint Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Iconsax.lamp_on, color: Theme.of(context).colorScheme.primary, size: 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'AI meminta detail lebih lanjut. Fokus pada tantangan spesifik dan decision-making process Anda.',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Recording area placeholder
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Iconsax.microphone_2,
                            color: Theme.of(context).colorScheme.onPrimary,
                            size: 40,
                          ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tap untuk Menjawab',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Bottom Info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        border: Border(
                          top: BorderSide(color: Theme.of(context).dividerTheme.color!),
                        ),
                      ),
                      child: Text(
                        'Follow-up questions membantu AI memahami depth dan critical thinking Anda',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).brightness == Brightness.light ? Colors.black.withOpacity(0.05) : Colors.transparent,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.pause),
                        label: const Text('Pause'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton.icon(
                        onPressed: () => context.router.push(const InterviewSessionUserQuestionsRoute()),
                        icon: const Icon(Icons.check),
                        label: const Text('Selesai Jawab'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(bool isOn, String label) {
    final isActive = _showTranscript == isOn;
    return InkWell(
      onTap: () => setState(() => _showTranscript = isOn),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}