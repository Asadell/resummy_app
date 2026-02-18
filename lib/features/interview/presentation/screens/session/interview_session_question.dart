import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/theme/app_colors.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'dart:async';

@RoutePage()
class InterviewSessionQuestionScreen extends StatefulWidget {
  const InterviewSessionQuestionScreen({super.key});

  @override
  State<InterviewSessionQuestionScreen> createState() =>
      _InterviewSessionQuestionScreenState();
}

class _InterviewSessionQuestionScreenState
    extends State<InterviewSessionQuestionScreen> {
  bool _showHint = false;
  static const int _maxQuestionDuration = 60;
  Timer? _recordingTimer;
  int _recordingDuration = _maxQuestionDuration;

  late final RecorderController _recorderController;

  @override
  void initState() {
    super.initState();
    _recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _recorderController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _recordingDuration = _maxQuestionDuration;
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_recordingDuration > 0) {
          _recordingDuration--;
        } else {
          _stopTimer();

          context.read<InterviewProvider>().stopRecording();
        }
      });
    });
  }

  void _stopTimer() {
    _recordingTimer?.cancel();
  }

  Future<void> _showExitBottomSheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final shouldExit = await showModalBottomSheet<bool>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Icon(
                  Iconsax.warning_2,
                  size: 48,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.exitInterviewTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.exitInterviewContent,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Theme.of(context).dividerColor),
                        ),
                        child: Text(
                            l10n.continueInterview,
                            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                          foregroundColor: Theme.of(context).colorScheme.onError,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        child: Text(l10n.exitYes),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ) ??
        false;

    if (shouldExit && context.mounted) {
      context.read<InterviewProvider>().resetInterview();
      context.router.push(const InterviewPrepRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<InterviewProvider>(
      builder: (context, provider, child) {
        if (provider.status == InterviewStatus.loading) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(l10n.generatingQuestions,
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
          );
        }

        if (provider.status == InterviewStatus.error) {
          return Scaffold(
            appBar: AppBar(title: Text(l10n.errorTitle)),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Iconsax.warning_2,
                        size: 64, color: Theme.of(context).colorScheme.error),
                    const SizedBox(height: 16),
                    Text(
                      provider.errorMessage ?? l10n.unknownError,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () {
                        provider.startInterview(
                          role: provider.role ?? "Candidate",
                          focus: provider.selectedFocus,
                        );
                      },
                      icon: const Icon(Iconsax.refresh),
                      label: Text(l10n.retry),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        provider.resetInterview();
                        context.router.push(const InterviewPrepRoute());
                      },
                      child: Text(l10n.back),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final question = provider.currentQuestion;

        if (question == null) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Iconsax.close_circle,
                  color: Theme.of(context).colorScheme.error),
              onPressed: () => _showExitBottomSheet(context),
            ),
            title: Text(l10n.questionXofY(
                provider.currentQuestionIndex + 1, provider.questions.length)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Row(
                    children: [
                      Icon(Iconsax.timer_1,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        '${(provider.totalSessionDurationSeconds ~/ 60).toString().padLeft(2, '0')}:${(provider.totalSessionDurationSeconds % 60).toString().padLeft(2, '0')}',
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
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: AppSizes.md, vertical: AppSizes.sm),
                  padding: const EdgeInsets.all(AppSizes.sm),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: BorderRadius.circular(AppSizes.sm),
                  ),
                  child: Row(
                    children: [
                      Text(
                        l10n.toggleText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      const Spacer(),
                      _buildToggleButton(true, l10n.on),
                      const SizedBox(width: AppSizes.sm),
                      _buildToggleButton(false, l10n.off),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: AppSizes.sm,
                            children: [
                              Icon(Iconsax.cpu_charge,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  size: 16),
                              Text(
                                l10n.behavioralStar,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(AppSizes.lg),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardTheme.color,
                            borderRadius: BorderRadius.circular(AppSizes.md),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: AppSizes.md,
                            children: [
                              Row(
                                children: [
                                  Icon(Iconsax.profile_circle,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      size: 24),
                                  const SizedBox(width: AppSizes.sm),
                                  Expanded(
                                    child: Text(
                                      l10n.aiInterviewer,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      provider.isPlayingQuestion
                                          ? Iconsax.stop_circle
                                          : Iconsax.refresh,
                                      color: provider.isPlayingQuestion
                                          ? Theme.of(context).colorScheme.error
                                          : Theme.of(context)
                                              .colorScheme
                                              .primary,
                                    ),
                                    onPressed: () =>
                                        provider.playQuestionAudio(),
                                    tooltip: provider.isPlayingQuestion
                                        ? l10n.stop
                                        : l10n.replayQuestion,
                                  ),
                                ],
                              ),
                              if (provider.isQuestionTextVisible)
                                Text(
                                  question.text,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(AppSizes.md),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(AppSizes.md),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: AppSizes.md,
                            children: [
                              InkWell(
                                onTap: () =>
                                    setState(() => _showHint = !_showHint),
                                child: Row(
                                  children: [
                                    Icon(Iconsax.lamp_on,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 20),
                                    const SizedBox(width: AppSizes.md),
                                    Text(
                                      l10n.hintStarMethod,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      _showHint
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: AppColors.primary700,
                                    ),
                                  ],
                                ),
                              ),
                              if (_showHint)
                                Text(
                                  question.starHint ?? l10n.hintStarDetail,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (provider.isRecording) ...[
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .error
                                        .withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Iconsax.microphone_2,
                                    color: Theme.of(context).colorScheme.error,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.recording,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${(_recordingDuration ~/ 60).toString().padLeft(2, '0')}:${(_recordingDuration % 60).toString().padLeft(2, '0')}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 16),
                                AudioWaveforms(
                                  enableGesture: true,
                                  size: Size(
                                      MediaQuery.of(context).size.width, 50),
                                  recorderController: _recorderController,
                                  waveStyle: WaveStyle(
                                    waveColor:
                                        Theme.of(context).colorScheme.error,
                                    extendWaveform: true,
                                    showMiddleLine: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ] else if (provider.isTranscribing) ...[
                          Center(
                            child: Column(
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.processingAnswer,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ] else if (provider.currentTranscript.isEmpty) ...[
                          Center(
                            child: Column(
                              children: [
                                Icon(Iconsax.message_text_1,
                                    size: 48,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest),
                                const SizedBox(height: 16),
                                Text(
                                  l10n.speakRelaxed,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        if (provider.currentTranscript.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Iconsax.note_text,
                                        size: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      l10n.transcriptRealTime,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  provider.currentTranscript,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    l10n.wordsAndSeconds(
                                        provider.currentTranscript
                                            .split(' ')
                                            .length,
                                        _recordingDuration),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .bottomNavigationBarTheme
                        .backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black.withValues(alpha: 0.05)
                            : Colors.transparent,
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (provider.isRecording)
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    await provider.cancelRecording();
                                    _stopTimer();
                                    setState(() {
                                      _recordingDuration = _maxQuestionDuration;
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(56),
                                    foregroundColor:
                                        Theme.of(context).colorScheme.error,
                                    side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error),
                                  ),
                                  child: Text(l10n.cancel),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    await provider.stopRecording();
                                    _stopTimer();
                                  },
                                  icon: const Icon(Icons.stop_circle),
                                  label: Text(l10n.stop),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                    foregroundColor:
                                        Theme.of(context).colorScheme.onError,
                                    minimumSize: const Size.fromHeight(56),
                                    elevation: 2,
                                  ),
                                ),
                              ),
                            ],
                          )
                        else if (provider.currentTranscript.isEmpty)
                          ElevatedButton.icon(
                            onPressed: provider.isTranscribing
                                ? null
                                : () async {
                                    _stopTimer();
                                    setState(() {
                                      _recordingDuration = _maxQuestionDuration;
                                    });

                                    await provider.startRecording();

                                    if (provider.isRecording) {
                                      _startTimer();
                                    }
                                  },
                            icon: provider.isTranscribing
                                ? const SizedBox()
                                : const Icon(Icons.mic),
                            label: Text(provider.isTranscribing
                                ? l10n.processing
                                : l10n.startAnswering),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(56),
                              elevation: 2,
                            ),
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: provider.isTranscribing
                                      ? null
                                      : () {
                                          provider.updateTranscript('');
                                          setState(() {
                                            _recordingDuration =
                                                _maxQuestionDuration;
                                          });
                                        },
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(56),
                                  ),
                                  child: Text(l10n.recordAgain),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: provider.isTranscribing
                                      ? null
                                      : () {
                                          provider.nextQuestion();
                                          if (provider.status ==
                                              InterviewStatus.analyzing) {
                                            context.router.push(
                                                const InterviewSessionClosingRoute());
                                          } else {
                                            setState(() {
                                              _recordingDuration =
                                                  _maxQuestionDuration;
                                              _stopTimer();
                                            });
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(56),
                                    elevation: 2,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(l10n.next),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.arrow_forward, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleButton(bool isOn, String label) {
    final provider = context.watch<InterviewProvider>();
    final isActive = provider.isQuestionTextVisible == isOn;

    return InkWell(
      onTap: () {
        final providerRead = context.read<InterviewProvider>();
        providerRead.setQuestionTextVisibility(isOn);

        if (isOn) {
          if (!providerRead.isPlayingQuestion) {
            providerRead.playQuestionAudio();
          }
        } else {
          providerRead.stopAudio();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
