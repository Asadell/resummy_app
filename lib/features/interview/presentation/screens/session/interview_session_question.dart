import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';
import 'dart:async';

@RoutePage()
class InterviewSessionQuestionScreen extends StatefulWidget {
  const InterviewSessionQuestionScreen({super.key});

  @override
  State<InterviewSessionQuestionScreen> createState() => _InterviewSessionQuestionScreenState();
}

class _InterviewSessionQuestionScreenState extends State<InterviewSessionQuestionScreen> {
  int _currentQuestion = 1;
  final int _totalQuestions = 5;
  bool _showTranscript = true;
  bool _isRecording = false;
  int _recordingSeconds = 0;
  Timer? _timer;
  String _transcript = '';
  bool _showHint = false;

  final List<String> _questions = [
    'Ceritakan pengalaman Anda saat memimpin sebuah project yang challenging dan bagaimana Anda mengatasinya.',
    'Bagaimana Anda menangani konflik dengan rekan kerja?',
    'Ceritakan tentang kegagalan terbesar Anda dan apa yang Anda pelajari.',
    'Bagaimana Anda memprioritaskan tugas ketika deadline mendesak?',
    'Mengapa Anda tertarik bekerja di perusahaan kami?',
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordingSeconds = 0;
      _transcript = '';
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingSeconds++;
        // Simulate real-time transcription
        if (_recordingSeconds == 3) {
          _transcript = 'Jadi saat saya di startup X, kami menghadapi deadline yang ketat untuk launch MVP.';
        } else if (_recordingSeconds == 8) {
          _transcript += ' Tim kami hanya 3 orang dan harus deliver frontend dan backend dalam 6 minggu...';
        }
      });
    });
  }

  void _stopRecording() {
    _timer?.cancel();
    setState(() {
      _isRecording = false;
    });
  }

  void _nextQuestion() {
    if (_currentQuestion < _totalQuestions) {
      setState(() {
        _currentQuestion++;
        _isRecording = false;
        _transcript = '';
        _recordingSeconds = 0;
      });
      _timer?.cancel();
    } else {
      context.router.push(const InterviewSessionFollowupRoute());
    }
  }

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
          icon: const Icon(Icons.close, color: AppColors.error),
          onPressed: _showExitDialog,
        ),
        title: Text('Question $_currentQuestion of $_totalQuestions'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Row(
                children: [
                  const Icon(Icons.timer, size: 16, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    '${(_recordingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_recordingSeconds % 60).toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
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
                    // Question Type Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🧠', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Text(
                            'Behavioral (STAR)',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Question Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text('👤', style: TextStyle(fontSize: 16)),
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
                          const SizedBox(height: 12),
                          Text(
                            _questions[_currentQuestion - 1],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Hint Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () => setState(() => _showHint = !_showHint),
                            child: Row(
                              children: [
                                const Text('💡', style: TextStyle(fontSize: 20)),
                                const SizedBox(width: 12),
                                Text(
                                  'Hint: Gunakan STAR method',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  _showHint ? Icons.expand_less : Icons.expand_more,
                                  color: AppColors.primary700,
                                ),
                              ],
                            ),
                          ),
                          if (_showHint) ...[
                            const SizedBox(height: 12),
                            Text(
                              'S: Jelaskan situasi\nT: Tugas Anda\nA: Aksi yang diambil\nR: Hasil terukur',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Your Answer',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Recording Indicator
                    if (_isRecording) ...[
                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.error.withOpacity(0.4),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.mic,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Recording...',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Waveform simulation
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                7,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 2),
                                  width: 4,
                                  height: 20 + (index % 3) * 10,
                                  decoration: BoxDecoration(
                                    color: AppColors.error,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ] else ...[
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Tidak ada batas waktu',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '💬 Bicara dengan santai',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Transcript Card
                    if (_showTranscript && _transcript.isNotEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(12),
                          border: const Border(
                            left: BorderSide(color: AppColors.primary, width: 4),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Transcript (Real-time):',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _transcript,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '~${_transcript.split(' ').length} words • ${_recordingSeconds}s',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_transcript.contains('startup')) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.secondary100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: AppColors.secondary, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Good: Anda sudah mulai dengan Situation!',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.secondary800,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
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
                        onPressed: _isRecording ? _stopRecording : null,
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
                        onPressed: _isRecording ? _nextQuestion : _startRecording,
                        icon: Icon(_isRecording ? Icons.check : Icons.mic),
                        label: Text(_isRecording ? 'Selesai Jawab' : 'Mulai Jawab'),
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
            color: isActive ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}