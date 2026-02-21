import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_analyzer_provider.dart';
import 'package:resummy_app/features/history/presentation/providers/history_provider.dart';
import 'package:resummy_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';

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
  late TextEditingController _jobDescController;
  String _selectedLanguage = 'id';
  bool _isJobDescExpanded = false;
  bool _wasAnalyzing = false;
  SuggestionPriority? _filterPriority;

  int? _selectedCvIndex;

  AppLocalizations get l10n => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    final provider = context.read<CvAnalyzerProvider>();
    final profile = context.read<ProfileProvider>().profile;
    
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CVBuilderProvider>().loadAllCVs();
    });

    _jobPositionController = TextEditingController(
        text: provider.jobPosition.isNotEmpty
            ? provider.jobPosition
            : (profile?.targetRole ?? ''));
    _jobDescController = TextEditingController(text: provider.jobDescription);

    if (provider.jobPosition.isEmpty && profile?.targetRole != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.setJobPosition(profile!.targetRole!);
      });
    }

    context.read<ProfileProvider>().addListener(_onProfileChanged);
    context.read<CvAnalyzerProvider>().addListener(_onAnalyzerChanged);
  }

  void _onAnalyzerChanged() {
    if (!mounted) return;
    final provider = context.read<CvAnalyzerProvider>();
    
    if (_wasAnalyzing && !provider.isAnalyzing && provider.hasResult) {
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<HistoryProvider>().loadActivities();
        }
      });
    }
    _wasAnalyzing = provider.isAnalyzing;
  }

  void _onProfileChanged() {
    if (!mounted) return;
    final profile = context.read<ProfileProvider>().profile;
    if (profile?.targetRole != null) {
      final provider = context.read<CvAnalyzerProvider>();
      if (_jobPositionController.text.isEmpty && provider.jobPosition.isEmpty) {
        setState(() {
          _jobPositionController.text = profile!.targetRole!;
          provider.setJobPosition(profile.targetRole!);
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _jobPositionController.dispose();
    _jobDescController.dispose();
    context.read<ProfileProvider>().removeListener(_onProfileChanged);
    context.read<CvAnalyzerProvider>().removeListener(_onAnalyzerChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cvAnalyzer),
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

  Widget _buildInputState(CvAnalyzerProvider provider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSizes.sm,
              children: [
                Text(
                  l10n.uploadYourCv,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  l10n.cvAnalyzerSetupDesc,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          AppSection(
            child: Consumer<CvAnalyzerProvider>(
              builder: (context, analyzerProvider, _) {
                final cvBuilderProvider = context.watch<CVBuilderProvider>();
                final allCvs = cvBuilderProvider.savedCVs;
                final recentCvs = allCvs.take(2).toList();
                final hasFile = analyzerProvider.hasFile;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: AppSizes.sm,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.selectCvToAnalyze,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (allCvs.length > 2)
                          TextButton(
                            onPressed: () => _showBrowseSheet(context, allCvs),
                            child: Text(l10n.viewAll),
                          ),
                      ],
                    ),
                    if (recentCvs.isEmpty && !hasFile)
                      Container(
                        padding: const EdgeInsets.all(AppSizes.md),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(AppSizes.sm),
                        ),
                        child: Row(
                          children: [
                            Icon(Iconsax.info_circle,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                                size: 20),
                            const SizedBox(width: AppSizes.sm),
                            Expanded(
                              child: Text(
                                l10n.noCvFound,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      ...recentCvs.asMap().entries.map((entry) {
                        final i = entry.key;
                        final cv = entry.value;
                        final isSelected = _selectedCvIndex == i;

                        return _buildCvItem(context,
                            index: i,
                            cv: cv,
                            isSelected: isSelected, onTap: () {
                          setState(() {
                            _selectedCvIndex = i;
                          });
                          _selectCvData(cv);
                        });
                      }),
                    ],
                    if (hasFile && _selectedCvIndex == -1)
                      Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withValues(alpha: 0.2),
                        shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                            borderRadius: BorderRadius.circular(AppSizes.sm)),
                        child: ListTile(
                          leading: Icon(Iconsax.document,
                              color: Theme.of(context).colorScheme.primary),
                          title:
                              Text(analyzerProvider.fileName ?? l10n.unknown),
                          subtitle: Text(analyzerProvider.fileSize ?? ''),
                          trailing: IconButton(
                            icon: const Icon(Iconsax.close_circle,
                                color: Colors.grey),
                            onPressed: () {
                              analyzerProvider.clearFile();
                              setState(() {
                                _selectedCvIndex = null;
                              });
                            },
                          ),
                        ),
                      ),
                    OutlinedButton.icon(
                      onPressed: () {
                        analyzerProvider.pickAndExtract().then((_) {
                          if (analyzerProvider.hasFile) {
                            setState(() {
                              _selectedCvIndex = -1;
                            });
                          }
                        });
                      },
                      icon: const Icon(Iconsax.document_upload),
                      label: Text(l10n.uploadNewCv),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        padding:
                            const EdgeInsets.symmetric(vertical: AppSizes.md),
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.sm),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          AppSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: AppSizes.md,
              children: [
                Text(
                  l10n.appliedPositionLabel,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: _jobPositionController,
                  decoration: InputDecoration(
                    labelText: l10n.appliedPositionLabel,
                    hintText: l10n.targetRoleHint,
                    prefixIcon: const Icon(Iconsax.briefcase),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.sm),
                    ),
                  ),
                  onChanged: provider.setJobPosition,
                ),
                _buildExpandableJobDesc(),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          AppSection(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: AppSizes.sm,
              children: [
                Row(
                  children: [
                    const Icon(Iconsax.language_square, size: 20),
                    const SizedBox(width: AppSizes.sm),
                    Text(
                      l10n.languageLabel,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                        value: 'id',
                        label: Text(l10n.indonesian),
                        icon: const Icon(Icons.flag, size: 16),
                      ),
                      ButtonSegment(
                        value: 'en',
                        label: Text(l10n.english),
                        icon: const Icon(Icons.flag, size: 16),
                      ),
                    ],
                    selected: {_selectedLanguage},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() => _selectedLanguage = newSelection.first);
                    },
                  ),
                ),
              ],
            ),
          ),
          if (provider.errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Container(
                padding: const EdgeInsets.all(AppSizes.sm),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(AppSizes.xs),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Iconsax.warning_2,
                        color: Colors.red.shade700, size: 20),
                    const SizedBox(width: AppSizes.sm),
                    Expanded(
                      child: Text(
                        provider.errorMessage!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSizes.md),
            child: FilledButton.icon(
              onPressed: (provider.hasFile ||
                          (_selectedCvIndex != null &&
                              _selectedCvIndex! >= 0)) &&
                      provider.jobPosition.isNotEmpty
                  ? () async {
                      provider.analyze(_selectedLanguage);
                    }
                  : null,
              icon: const Icon(Iconsax.scan_barcode),
              label: Text(l10n.startAnalysis),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.sm),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.xl),
        ],
      ),
    );
  }

  Widget _buildExpandableJobDesc() {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Iconsax.document_text_1),
          title: Text('${l10n.jobDescription} ${l10n.optionalField}'),
          subtitle: Text(l10n.jobDescSubtitle),
          trailing: Icon(
            _isJobDescExpanded ? Iconsax.arrow_up_2 : Iconsax.arrow_down_1,
          ),
          onTap: () {
            setState(() => _isJobDescExpanded = !_isJobDescExpanded);
          },
        ),
        if (_isJobDescExpanded)
          Padding(
            padding: const EdgeInsets.only(top: AppSizes.sm),
            child: TextField(
              controller: _jobDescController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: l10n.jobDescPasteHint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSizes.sm),
                ),
              ),
              onChanged: context.read<CvAnalyzerProvider>().setJobDescription,
            ),
          ),
      ],
    );
  }

  Widget _buildLoadingState(CvAnalyzerProvider provider) {
    final isConverting = provider.isConverting;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              isConverting ? l10n.applyingSuggestions : l10n.analyzingCv,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isConverting ? l10n.applyingSuggestions : l10n.estimateTime,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultState(CvAnalyzerProvider provider) {
    final result = provider.result!;

    return Stack(
      children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.all(AppSizes.sm),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: Theme.of(context).colorScheme.onPrimary,
                unselectedLabelColor:
                    Theme.of(context).colorScheme.onSurfaceVariant,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(
                    height: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Iconsax.chart_1, size: 16),
                        const SizedBox(width: 8),
                        Text(l10n.report),
                      ],
                    ),
                  ),
                  Tab(
                    height: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Iconsax.message_edit, size: 16),
                        const SizedBox(width: 8),
                        Text(l10n.suggestion),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildReportTab(CvAnalysisResult result) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSection(
            child: _buildScoreCircle(result),
          ),
          const SizedBox(height: AppSizes.sm),
          AppSection(
            child: _buildMetricsSection(result.metrics),
          ),
          const SizedBox(height: AppSizes.sm),
          if (result.summaryFeedback.isNotEmpty) ...[
            AppSection(
              child: _buildSectionCard(
                title: l10n.summary,
                icon: Iconsax.message_text,
                child: Text(result.summaryFeedback),
              ),
            ),
            const SizedBox(height: AppSizes.sm),
          ],
          if (result.highlights.isNotEmpty) ...[
            AppSection(
              child: _buildSectionCard(
                title: l10n.strengths,
                icon: Iconsax.like_1,
                color: Colors.green,
                child: Column(
                  children: result.highlights
                      .map((h) => _buildBulletPoint(h, Colors.green))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.sm),
          ],
          if (result.improvements.isNotEmpty) ...[
            AppSection(
              child: _buildSectionCard(
                title: l10n.improvements,
                icon: Iconsax.warning_2,
                color: Colors.orange,
                child: Column(
                  children: result.improvements
                      .map((i) => _buildBulletPoint(i, Colors.orange))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.sm),
          ],
          if (result.missingKeywords.isNotEmpty) ...[
            AppSection(
              child: _buildSectionCard(
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
            ),
            const SizedBox(height: AppSizes.xl),
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
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
                mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 24),
          Text(
            l10n.overallAtsScore,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsSection(CvScoreMetrics metrics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.detailScore,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        _buildMetricBar(l10n.keywordMatch, metrics.keywordMatch, Colors.blue),
        const SizedBox(height: 12),
        _buildMetricBar(l10n.quantifiableAchievements,
            metrics.quantifiableAchievements, Colors.green),
        const SizedBox(height: 12),
        _buildMetricBar(l10n.structureCompleteness,
            metrics.structureCompleteness, Colors.purple),
        const SizedBox(height: 12),
        _buildMetricBar(l10n.languageProfessionalism,
            metrics.languageProfessionalism, Colors.orange),
      ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
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

  Widget _buildSuggestionsTab(
      CvAnalysisResult result, CvAnalyzerProvider provider) {
    final filteredSuggestions = _filterPriority == null
        ? result.suggestions
        : result.suggestions
            .where((s) => s.priority == _filterPriority)
            .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSection(
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildStatChip(
                          l10n.pendingStatus, result.pendingCount, Colors.blue),
                      const SizedBox(width: 8),
                      _buildStatChip(l10n.appliedStatus, result.appliedCount,
                          Colors.green),
                      const SizedBox(width: 8),
                      _buildStatChip(l10n.dismissedStatus, result.dismissedCount,
                          Colors.grey),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
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
                        onSelected: (_) => setState(
                            () => _filterPriority = SuggestionPriority.high),
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
                        onSelected: (_) => setState(
                            () => _filterPriority = SuggestionPriority.low),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.sm),
          if (filteredSuggestions.isEmpty)
            AppSection(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text(
                    l10n.noSuggestionsForFilter,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
            )
          else
            ...filteredSuggestions.map((suggestion) => Column(
                  children: [
                    AppSection(
                      backgroundColor: suggestion.isApplied
                          ? Colors.green.shade50
                          : suggestion.isDismissed
                              ? Colors.grey.shade100
                              : null,
                      child: _buildSuggestionCard(suggestion, provider),
                    ),
                    const SizedBox(height: AppSizes.sm),
                  ],
                )),
          const SizedBox(height: 80), 
        ],
      ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    _getPriorityLabel(suggestion.priority).toUpperCase(),
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.info_circle,
                      size: 14, color: Colors.blue.shade700),
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
            if (!suggestion.isApplied && !suggestion.isDismissed)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          provider.dismissSuggestion(suggestion.id),
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
                label: Text(
                    suggestion.isApplied ? l10n.undoApply : l10n.undoDismiss),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
              ),
          ],
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

  String _sourceLabel(AppLocalizations l10n, String source) {
    switch (source) {
      case 'builder':
        return l10n.cvSourceBuilder;
      case 'ats_converter':
        return l10n.cvSourceAtsConverter;
      case 'analyzer':
        return l10n.cvSourceAnalyzer;
      default:
        return l10n.cvSourceBuilder;
    }
  }

  IconData _sourceIcon(String source) {
    switch (source) {
      case 'builder':
        return Iconsax.document_text;
      case 'ats_converter':
        return Iconsax.magic_star;
      case 'analyzer':
        return Iconsax.chart_2;
      default:
        return Iconsax.document_text;
    }
  }

  Color _sourceColor(BuildContext context, String source) {
    switch (source) {
      case 'builder':
        return Theme.of(context).colorScheme.primary;
      case 'ats_converter':
        return Colors.purple;
      case 'analyzer':
        return Colors.green;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  Future<void> _selectCvData(dynamic cv) async {
    if (cv is CVData) {
      context.read<CvAnalyzerProvider>().setExtractedText(cv.toPlainText());
    }
  }

  void _showBrowseSheet(BuildContext context, List<dynamic> allCvs) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BrowseCvSheet(
        allCvs: allCvs,
        selectedIndex: _selectedCvIndex,
        sourceLabel: (s) => _sourceLabel(l10n, s),
        sourceIcon: _sourceIcon,
        sourceColor: (s) => _sourceColor(ctx, s),
        onSelected: (index) {
          setState(() {
            _selectedCvIndex = index;
            Provider.of<CvAnalyzerProvider>(context, listen: false).clearFile();
          });
        },
      ),
    );
  }

  Widget _buildCvItem(
    BuildContext context, {
    required int index,
    required dynamic cv,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final color = _sourceColor(context, cv.source);
    final dateStr = (cv.updatedAt != null)
        ? "${cv.updatedAt.day}/${cv.updatedAt.month}/${cv.updatedAt.year}"
        : "";

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSizes.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSizes.md),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSizes.sm),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Iconsax.record_circle : Iconsax.stop_circle,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSizes.sm),
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(_sourceIcon(cv.source), color: color, size: 18),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cv.name.isNotEmpty ? cv.name : l10n.cvNumber(index + 1),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${_sourceLabel(l10n, cv.source)} • $dateStr',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleBuatCvAts(CvAnalyzerProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.fromLTRB(
          24,
          12,
          24,
          MediaQuery.of(modalContext).viewInsets.bottom + 24,
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
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Icon(
              Iconsax.document_text,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.createNewAtsCvTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.createCvAtsConfirmationDesc,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(modalContext),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(l10n.cancel),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () async {
                      Navigator.pop(modalContext);

                      final cvData = await provider.convertAppliedToCv();

                      if (cvData != null && mounted) {
                        context.read<CVBuilderProvider>().loadCvData(cvData);

                        context.router.push(const CvBuilderStep1Route());
                      } else if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(provider.errorMessage ??
                                l10n.errorSavingProfile),
                            backgroundColor: Colors.red,
                          ),
                        );
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

  String _getPriorityLabel(SuggestionPriority priority) {
    switch (priority) {
      case SuggestionPriority.high:
        return l10n.priorityHigh;
      case SuggestionPriority.medium:
        return l10n.priorityMedium;
      case SuggestionPriority.low:
        return l10n.priorityLow;
    }
  }
}

class _BrowseCvSheet extends StatefulWidget {
  final List<dynamic> allCvs;
  final int? selectedIndex;
  final String Function(String) sourceLabel;
  final IconData Function(String) sourceIcon;
  final Color Function(String) sourceColor;
  final void Function(int) onSelected;

  const _BrowseCvSheet({
    required this.allCvs,
    required this.selectedIndex,
    required this.sourceLabel,
    required this.sourceIcon,
    required this.sourceColor,
    required this.onSelected,
  });

  @override
  State<_BrowseCvSheet> createState() => _BrowseCvSheetState();
}

class _BrowseCvSheetState extends State<_BrowseCvSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filtered = _query.isEmpty
        ? widget.allCvs
        : widget.allCvs
            .where((cv) =>
                cv.name.toLowerCase().contains(_query.toLowerCase()) ||
                cv.source.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(AppSizes.md)),
          ),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: AppSizes.sm),
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(AppSizes.xs),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppSizes.lg, right: AppSizes.lg, bottom: AppSizes.sm),
                child: Text(
                  l10n.selectCv,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.lg, vertical: AppSizes.sm),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.searchCv,
                    prefixIcon: const Icon(Iconsax.search_normal, size: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.sm),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSizes.md, vertical: AppSizes.sm),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          l10n.noCvFound,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      )
                    : ListView.separated(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.lg, vertical: AppSizes.sm),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppSizes.sm),
                        itemBuilder: (context, i) {
                          final cv = filtered[i];
                          final globalIndex = widget.allCvs.indexOf(cv);
                          final isSelected =
                              widget.selectedIndex == globalIndex;
                          final color = widget.sourceColor(cv.source);
                          final dateStr = (cv.updatedAt != null)
                              ? "${cv.updatedAt.day}/${cv.updatedAt.month}/${cv.updatedAt.year}"
                              : "";

                          return InkWell(
                            onTap: () {
                              widget.onSelected(globalIndex);
                              Navigator.of(context).pop();
                            },
                            borderRadius: BorderRadius.circular(AppSizes.sm),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(AppSizes.md),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primaryContainer
                                    : Theme.of(context)
                                        .colorScheme
                                        .surfaceContainerHighest,
                                border: Border.all(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.transparent,
                                  width: isSelected ? 2 : 1,
                                ),
                                borderRadius:
                                    BorderRadius.circular(AppSizes.sm),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        color.withValues(alpha: 0.15),
                                    child: Icon(widget.sourceIcon(cv.source),
                                        color: color, size: 20),
                                  ),
                                  const SizedBox(width: AppSizes.sm),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cv.name.isNotEmpty
                                              ? cv.name
                                              : 'CV ${globalIndex + 1}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${widget.sourceLabel(cv.source)} • $dateStr',
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
                                  if (isSelected)
                                    Icon(Iconsax.tick_circle,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
