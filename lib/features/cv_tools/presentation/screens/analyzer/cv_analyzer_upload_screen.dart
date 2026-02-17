import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/data/services/cv_analyzer_service.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_analyzer_provider.dart';
import 'package:resummy_app/features/profile/presentation/providers/profile_provider.dart';

@RoutePage()
class CvAnalyzerUploadScreen extends StatefulWidget {
  const CvAnalyzerUploadScreen({super.key});

  @override
  State<CvAnalyzerUploadScreen> createState() => _CvAnalyzerUploadScreenState();
}

class _CvAnalyzerUploadScreenState extends State<CvAnalyzerUploadScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController _jobPositionController;
  String _selectedLanguage = 'id';
  bool _isJobDescExpanded = false;
  SuggestionPriority? _filterPriority;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    final profile = context.read<ProfileProvider>().profile;
    _jobPositionController = TextEditingController(text: profile?.targetRole ?? '');
    
    // Set initial position in provider if auto-filled
    if (profile?.targetRole != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<CvAnalyzerProvider>().setJobPosition(profile!.targetRole!);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _jobPositionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cvAnalyzer),
        // actions: [
        //   Consumer<CvAnalyzerProvider>(
        //     builder: (context, provider, _) {
        //       if (provider.hasResult) {
        //         return IconButton(
        //           icon: const Icon(Iconsax.refresh),
        //           onPressed: () {
        //             provider.clearAll();
        //             setState(() => _tabController.index = 0);
        //           },
        //           tooltip: 'Analisis CV Baru',
        //         );
        //       }
        //       return const SizedBox.shrink();
        //     },
        //   ),
        // ],
      ),
      body: Consumer<CvAnalyzerProvider>(
        builder: (context, provider, _) {
          if (provider.isAnalyzing || provider.isConverting) {
            return _buildLoadingState(provider);
          }

          if (provider.hasResult) {
            return _buildResultState(provider);
          }

          return _buildInputState(provider);
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // STATE 1: INPUT
  // ═══════════════════════════════════════════════════════════════

  Widget _buildInputState(CvAnalyzerProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Text(
            l10n.uploadYourCv,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.cvAnalyzerSetupDesc,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 24),

          // PDF Upload Card
          _buildUploadCard(provider),
          const SizedBox(height: 16),

          // Job Position
          TextField(
            controller: _jobPositionController,
            decoration: InputDecoration(
              labelText: l10n.appliedPositionLabel,
              hintText: l10n.targetRoleHint,
              prefixIcon: const Icon(Iconsax.briefcase),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: provider.setJobPosition,
          ),
          const SizedBox(height: 16),

          // Job Description (Expandable)
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Iconsax.document_text_1),
                  title: Text('${l10n.jobDescription} ${l10n.optionalField}'),
                  subtitle: Text(l10n.jobDescSubtitle),
                  trailing: Icon(
                    _isJobDescExpanded
                        ? Iconsax.arrow_up_2
                        : Iconsax.arrow_down_1,
                  ),
                  onTap: () {
                    setState(() => _isJobDescExpanded = !_isJobDescExpanded);
                  },
                ),
                if (_isJobDescExpanded)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: l10n.jobDescPasteHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: provider.setJobDescription,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Language Selector
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Iconsax.language_square, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        l10n.languageLabel,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'id',
                        label: Text(l10n.indonesian),
                        icon: Icon(Icons.flag, size: 16),
                      ),
                      ButtonSegment(
                        value: 'en',
                        label: Text(l10n.english),
                        icon: Icon(Icons.flag, size: 16),
                      ),
                    ],
                    selected: {_selectedLanguage},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() => _selectedLanguage = newSelection.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Error Message
          if (provider.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.warning_2, color: Colors.red.shade700, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      provider.errorMessage!,
                      style: TextStyle(color: Colors.red.shade700),
                    ),
                  ),
                ],
              ),
            ),
          if (provider.errorMessage != null) const SizedBox(height: 16),

          // Analyze Button
          FilledButton.icon(
            onPressed: provider.hasFile && provider.jobPosition.isNotEmpty
                ? () => provider.analyze(_selectedLanguage)
                : null,
            icon: const Icon(Iconsax.scan_barcode),
            label: Text(l10n.startAnalysis),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadCard(CvAnalyzerProvider provider) {
    if (provider.hasFile) {
      return Card(
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Iconsax.document, color: Colors.green.shade700),
          ),
          title: Text(provider.fileName ?? 'Unknown'),
          subtitle: Text(provider.fileSize ?? ''),
          trailing: IconButton(
            icon: const Icon(Iconsax.trash, color: Colors.red),
            onPressed: provider.clearFile,
          ),
        ),
      );
    }

    return Card(
      child: InkWell(
        onTap: provider.isPickingFile ? null : provider.pickAndExtract,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              if (provider.isPickingFile)
                const CircularProgressIndicator()
              else
                Icon(
                  Iconsax.document_upload,
                  size: 48,
                  color: Theme.of(context).primaryColor,
                ),
              const SizedBox(height: 16),
              Text(
                provider.isPickingFile ? l10n.processingCv : l10n.uploadCv,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.max5Pages,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // STATE 2: LOADING
  // ═══════════════════════════════════════════════════════════════

  Widget _buildLoadingState(CvAnalyzerProvider provider) {
    final isConverting = provider.isConverting;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            isConverting ? l10n.applyingSuggestions : l10n.analyzingCv,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            isConverting
                ? l10n.applyingSuggestions
                : l10n.estimateTime,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // STATE 3: RESULTS
  // ═══════════════════════════════════════════════════════════════

  Widget _buildResultState(CvAnalyzerProvider provider) {
    final result = provider.result!;

    return Stack(
      children: [
        Column(
          children: [
            // Tab Bar
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: l10n.report, icon: const Icon(Iconsax.chart_1)),
                  Tab(text: l10n.suggestion, icon: const Icon(Iconsax.message_edit)),
                ],
              ),
            ),
            // Tab Views
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildReportTab(result),
                  _buildSuggestionsTab(result, provider),
                ],
              ),
            ),
          ],
        ),
        _buildCvFab(result, provider),
      ],
    );
  }

  // ─── Report Tab ──────────────────────────────────────────────

  Widget _buildReportTab(CvAnalysisResult result) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Score Circle
          _buildScoreCircle(result),
          const SizedBox(height: 24),

          // Metrics
          _buildMetricsSection(result.metrics),
          const SizedBox(height: 24),

          // Summary Feedback
          if (result.summaryFeedback.isNotEmpty) ...[
            _buildSectionCard(
              title: l10n.summary,
              icon: Iconsax.message_text,
              child: Text(result.summaryFeedback),
            ),
            const SizedBox(height: 16),
          ],

          // Highlights
          if (result.highlights.isNotEmpty) ...[
            _buildSectionCard(
              title: l10n.strengths,
              icon: Iconsax.like_1,
              color: Colors.green,
              child: Column(
                children: result.highlights
                    .map((h) => _buildBulletPoint(h, Colors.green))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Improvements
          if (result.improvements.isNotEmpty) ...[
            _buildSectionCard(
              title: l10n.improvements,
              icon: Iconsax.warning_2,
              color: Colors.orange,
              child: Column(
                children: result.improvements
                    .map((i) => _buildBulletPoint(i, Colors.orange))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Missing Keywords
          if (result.missingKeywords.isNotEmpty) ...[
            _buildSectionCard(
              title: l10n.missingKeywords,
              icon: Iconsax.search_normal,
              color: Colors.red,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: result.missingKeywords
                    .map((kw) => Chip(
                          label: Text(kw),
                          backgroundColor: Colors.red.shade50,
                          side: BorderSide(color: Colors.red.shade200),
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildScoreCircle(CvAnalysisResult result) {
    final color = result.overallScore >= 85
        ? Colors.green
        : result.overallScore >= 70
            ? Colors.blue
            : result.overallScore >= 50
                ? Colors.orange
                : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: result.overallScore / 100,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${result.overallScore}',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                    ),
                    Text(
                      result.grade,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.overallAtsScore,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsSection(CvScoreMetrics metrics) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.detailScore,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _buildMetricBar(l10n.keywordMatch, metrics.keywordMatch, Colors.blue),
            const SizedBox(height: 12),
            _buildMetricBar(l10n.quantifiableAchievements,
                metrics.quantifiableAchievements, Colors.green),
            const SizedBox(height: 12),
            _buildMetricBar(
                l10n.structureCompleteness, metrics.structureCompleteness, Colors.purple),
            const SizedBox(height: 12),
            _buildMetricBar(l10n.languageProfessionalism, metrics.languageProfessionalism,
                Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBar(String label, int value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
            Text(l10n.score(value),
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: value / 100,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    Color? color,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(Iconsax.tick_circle, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  // ─── Suggestions Tab ─────────────────────────────────────────

  Widget _buildSuggestionsTab(
      CvAnalysisResult result, CvAnalyzerProvider provider) {
    final filteredSuggestions = _filterPriority == null
        ? result.suggestions
        : result.suggestions
            .where((s) => s.priority == _filterPriority)
            .toList();

    return Column(
      children: [
        // Filter & Stats
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatChip('Pending', result.pendingCount, Colors.blue),
                  _buildStatChip('Applied', result.appliedCount, Colors.green),
                  _buildStatChip(
                      'Dismissed', result.dismissedCount, Colors.grey),
                ],
              ),
              const SizedBox(height: 12),
              // Priority Filter
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: Text(l10n.filterAll),
                      selected: _filterPriority == null,
                      onSelected: (_) =>
                          setState(() => _filterPriority = null),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: Text(l10n.filterHigh),
                      selected: _filterPriority == SuggestionPriority.high,
                      onSelected: (_) =>
                          setState(() => _filterPriority = SuggestionPriority.high),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: Text(l10n.filterMedium),
                      selected: _filterPriority == SuggestionPriority.medium,
                      onSelected: (_) => setState(
                          () => _filterPriority = SuggestionPriority.medium),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: Text(l10n.filterLow),
                      selected: _filterPriority == SuggestionPriority.low,
                      onSelected: (_) =>
                          setState(() => _filterPriority = SuggestionPriority.low),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Suggestions List
        Expanded(
          child: filteredSuggestions.isEmpty
              ? Center(
                  child: Text(
                    l10n.noSuggestionsForFilter,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredSuggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = filteredSuggestions[index];
                    // Add extra padding for the last item to avoid FAB overlap
                    if (index == filteredSuggestions.length - 1) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: _buildSuggestionCard(suggestion, provider),
                      );
                    }
                    return _buildSuggestionCard(suggestion, provider);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildStatChip(String label, int count, Color color) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: color,
        child: Text(
          '$count',
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
      label: Text(label),
    );
  }

  Widget _buildSuggestionCard(
      CvSuggestion suggestion, CvAnalyzerProvider provider) {
    final priorityColor = suggestion.priority == SuggestionPriority.high
        ? Colors.red
        : suggestion.priority == SuggestionPriority.medium
            ? Colors.orange
            : Colors.blue;

    final cardColor = suggestion.isApplied
        ? Colors.green.shade50
        : suggestion.isDismissed
            ? Colors.grey.shade100
            : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: priorityColor),
                  ),
                  child: Text(
                    suggestion.priority.name.toUpperCase(),
                    style: TextStyle(
                      color: priorityColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    suggestion.sectionTitle,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Chip(
                  label: Text(
                    suggestion.category.label,
                    style: const TextStyle(fontSize: 10),
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Original Text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.close_circle,
                          size: 16, color: Colors.red.shade700),
                      const SizedBox(width: 4),
                      Text(
                        l10n.originalText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(suggestion.original),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Suggested Text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.tick_circle,
                          size: 16, color: Colors.green.shade700),
                      const SizedBox(width: 4),
                      Text(
                        l10n.suggestion,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(suggestion.suggestion),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Reason
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.info_circle, size: 14, color: Colors.blue.shade700),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      suggestion.reason,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Actions
            if (!suggestion.isApplied && !suggestion.isDismissed)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => provider.dismissSuggestion(suggestion.id),
                      icon: const Icon(Iconsax.close_circle, size: 16),
                      label: Text(l10n.dismiss),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => provider.applySuggestion(suggestion.id),
                      icon: const Icon(Iconsax.tick_circle, size: 16),
                      label: Text(l10n.apply),
                    ),
                  ),
                ],
              )
            else
              OutlinedButton.icon(
                onPressed: () => provider.undoSuggestion(suggestion.id),
                icon: const Icon(Iconsax.refresh, size: 16),
                label: Text(suggestion.isApplied ? l10n.undoApply : l10n.undoDismiss),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildCvFab(CvAnalysisResult result, CvAnalyzerProvider provider) {
    if (result.appliedCount == 0) return const SizedBox.shrink();

    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: FloatingActionButton.extended(
        onPressed: () => _handleBuatCvAts(provider),
        icon: const Icon(Iconsax.magicpen),
        label: Text(l10n.createCvFromSuggestions(result.appliedCount)),
      ),
    );
  }

  void _handleBuatCvAts(CvAnalyzerProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          top: 8,
          left: 24,
          right: 24,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Iconsax.magicpen,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n.createNewAtsCvTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              l10n.createCvAtsConfirmationDesc,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () async {
                      Navigator.pop(context); // Tutup bottom sheet
                      
                      // Proses convert
                      final cvData = await provider.convertAppliedToCv();
                      
                      if (cvData != null && mounted) {
                        // Masukkan ke CV Builder Provider
                        context.read<CVBuilderProvider>().loadCvData(cvData);
                        
                        // Navigasi ke Step 1 CV Builder
                        context.router.push(const CvBuilderStep1Route());
                      }
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(l10n.createNow),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
