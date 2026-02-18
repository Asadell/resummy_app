import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/utils/pdf_utils.dart';

import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';

@RoutePage()
class InterviewSetupStep1Screen extends StatefulWidget {
  const InterviewSetupStep1Screen({super.key});

  @override
  State<InterviewSetupStep1Screen> createState() =>
      _InterviewSetupStep1ScreenState();
}

class _InterviewSetupStep1ScreenState extends State<InterviewSetupStep1Screen> {
  /// null = no selection yet; -1 = uploaded CV
  int? _selectedCvIndex;
  String? _uploadedCvName;
  String? _uploadedCvText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CVBuilderProvider>().loadAllCVs();
    });
  }

  // ─── helpers ────────────────────────────────────────────────────────────────

  /// Build a plain-text representation of a CVData for the AI prompt.
  String _buildCvText(CVData cv) {
    final buf = StringBuffer();
    buf.writeln('Name: ${cv.header.name}');
    if (cv.header.email != null) buf.writeln('Email: ${cv.header.email}');
    if (cv.header.phone != null) buf.writeln('Phone: ${cv.header.phone}');
    if (cv.header.location != null) buf.writeln('Location: ${cv.header.location}');

    final summary = cv.summarySection?.content ?? '';
    if (summary.isNotEmpty) {
      buf.writeln('\nSummary:\n$summary');
    }

    final exp = cv.workExperience;
    if (exp.isNotEmpty) {
      buf.writeln('\nWork Experience:');
      for (final e in exp) {
        buf.writeln('- ${e.jobTitle} at ${e.companyName} (${e.employmentType})');
        buf.writeln('  ${e.responsibilities}');
      }
    }

    final edu = cv.education;
    if (edu.isNotEmpty) {
      buf.writeln('\nEducation:');
      for (final e in edu) {
        buf.writeln('- ${e.degree} in ${e.major}, ${e.institution}');
      }
    }

    final skills = cv.skills;
    if (skills.isNotEmpty) {
      buf.writeln('\nSkills: ${skills.join(', ')}');
    }

    return buf.toString();
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

  // ─── file picker ────────────────────────────────────────────────────────────

  Future<void> _pickCvFile() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        final path = result.files.single.path;
        if (path != null) {
          final text = await PdfUtils().extractText(path);
          setState(() {
            _uploadedCvName = result.files.single.name;
            _uploadedCvText = text;
            _selectedCvIndex = -1;
          });
        }
      }
    } catch (e) {
      String message = '${l10n.errorTitle}: $e';
      if (e.toString().contains('MAX_PAGES_EXCEEDED')) {
        message = l10n.max5PagesInterview;
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // ─── browse-all bottom sheet ─────────────────────────────────────────────────

  void _showBrowseSheet(List<CVData> allCvs) {
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
            _uploadedCvName = null;
            _uploadedCvText = null;
          });
        },
      ),
    );
  }

  // ─── build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.aiInterviewSimulator),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.router.push(const InterviewPrepRoute()),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSizes.sm,
            children: [
              // ── hero card ──
              AppSection(
                child: Column(
                  spacing: AppSizes.md,
                  children: [
                    Icon(
                      Iconsax.microphone_2,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Column(
                      spacing: AppSizes.xs,
                      children: [
                        Text(
                          l10n.aiInterviewSimulator,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          l10n.setupStep1Desc,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── format info ──
              AppSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSizes.sm,
                  children: [
                    Row(
                      children: [
                        Icon(Iconsax.document_text,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20),
                        const SizedBox(width: AppSizes.sm),
                        Text(
                          l10n.formatInterview,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Wrap(
                      runSpacing: AppSizes.sm,
                      children: [
                        _buildInfoChip(
                          context,
                          Iconsax.timer_1,
                          l10n.durationAprox,
                          color: Colors.blue,
                        ),
                        _buildInfoChip(
                          context,
                          Iconsax.message_question,
                          l10n.questionsCount,
                          color: Colors.orange,
                        ),
                        _buildInfoChip(
                          context,
                          Iconsax.global,
                          l10n.languageOption,
                          color: Colors.purple,
                        ),
                        _buildInfoChip(
                          context,
                          Iconsax.star,
                          l10n.methodStar,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── CV selection ──
              Consumer<CVBuilderProvider>(
                builder: (context, cvProvider, _) {
                  final allCvs = cvProvider.savedCVs;
                  final recentCvs = allCvs.take(2).toList();

                  return AppSection(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSizes.sm,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.step1SelectCv,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            if (allCvs.length > 2)
                              TextButton(
                                onPressed: () => _showBrowseSheet(allCvs),
                                child: Text(l10n.viewAll),
                              ),
                          ],
                        ),

                        // Recent CVs from provider
                        if (recentCvs.isEmpty)
                          _buildEmptyCvHint(context, l10n)
                        else
                          ...recentCvs.asMap().entries.map((entry) {
                            final i = entry.key;
                            final cv = entry.value;
                            return _buildCvItem(
                              context,
                              index: i,
                              cv: cv,
                              l10n: l10n,
                            );
                          }),

                        // Uploaded CV
                        if (_uploadedCvName != null)
                          _buildUploadedItem(context, l10n),

                        // Upload option
                        _buildUploadOption(context, l10n),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context, l10n),
    );
  }

  // ─── sub-widgets ─────────────────────────────────────────────────────────────

  Widget _buildInfoChip(
    BuildContext context,
    IconData icon,
    String text, {
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.sm,
        vertical: AppSizes.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSizes.sm),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color,
          ),
          const SizedBox(width: AppSizes.xs),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCvHint(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.sm),
      ),
      child: Row(
        children: [
          Icon(Iconsax.info_circle,
              color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              l10n.noCvFound,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCvItem(
    BuildContext context, {
    required int index,
    required CVData cv,
    required AppLocalizations l10n,
  }) {
    final isSelected = _selectedCvIndex == index;
    final color = _sourceColor(context, cv.source);
    final date = DateFormat.yMMMd().format(cv.updatedAt);

    return InkWell(
      onTap: () => setState(() {
        _selectedCvIndex = index;
        _uploadedCvName = null;
        _uploadedCvText = null;
      }),
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
                    '${_sourceLabel(l10n, cv.source)} • $date',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
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

  Widget _buildUploadedItem(BuildContext context, AppLocalizations l10n) {
    final isSelected = _selectedCvIndex == -1;
    return InkWell(
      onTap: () => setState(() => _selectedCvIndex = -1),
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
              backgroundColor:
                  Theme.of(context).colorScheme.secondary.withValues(alpha: 0.15),
              child: Icon(Iconsax.document_upload,
                  color: Theme.of(context).colorScheme.secondary, size: 18),
            ),
            const SizedBox(width: AppSizes.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _uploadedCvName!,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    l10n.uploadedFromDevice,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
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

  Widget _buildUploadOption(BuildContext context, AppLocalizations l10n) {
    return OutlinedButton.icon(
      onPressed: _pickCvFile,
      icon: const Icon(Iconsax.document_upload),
      label: Text(l10n.uploadNewCv),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
        side: BorderSide(color: Theme.of(context).colorScheme.primary),
        foregroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.sm),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.md),
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
        child: Consumer<CVBuilderProvider>(
          builder: (context, cvProvider, _) {
            final canContinue = _selectedCvIndex != null;
            return ElevatedButton(
              onPressed: canContinue
                  ? () {
                      final provider = context.read<InterviewProvider>();
                      String cvText = '';
                      String cvName = '';

                      if (_selectedCvIndex == -1 && _uploadedCvText != null) {
                        cvText = _uploadedCvText!;
                        cvName = _uploadedCvName ?? 'Uploaded CV.pdf';
                      } else if (_selectedCvIndex != null &&
                          _selectedCvIndex! >= 0) {
                        final cv = cvProvider.savedCVs[_selectedCvIndex!];
                        cvText = _buildCvText(cv);
                        cvName = cv.name.isNotEmpty
                            ? cv.name
                            : l10n.cvNumber(_selectedCvIndex! + 1);
                      }

                      provider.updateCvText(cvText);
                      provider.updateCvFileName(cvName);
                      context.router.push(const InterviewSetupStep2Route());
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              child: Text('${l10n.continueText} →'),
            );
          },
        ),
      ),
    );
  }
}

// ─── Browse-all bottom sheet ──────────────────────────────────────────────────

class _BrowseCvSheet extends StatefulWidget {
  final List<CVData> allCvs;
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
              // Handle
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
                  l10n.step1SelectCv,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              // Search
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
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
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
                          final date =
                              DateFormat.yMMMd().format(cv.updatedAt);

                          return InkWell(
                            onTap: () {
                              widget.onSelected(globalIndex);
                              Navigator.of(context).pop();
                            },
                            borderRadius:
                                BorderRadius.circular(AppSizes.sm),
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
                                      ? Theme.of(context)
                                          .colorScheme
                                          .primary
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
                                    child: Icon(
                                        widget.sourceIcon(cv.source),
                                        color: color,
                                        size: 20),
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
                                                  fontWeight:
                                                      FontWeight.w600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${widget.sourceLabel(cv.source)} • $date',
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
