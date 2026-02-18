import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/features/cv_tools/data/services/cv_ats_converter_service.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_preview_card.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';

@RoutePage()
class CvAtsConverterScreen extends StatefulWidget {
  const CvAtsConverterScreen({super.key});

  @override
  State<CvAtsConverterScreen> createState() => _CvAtsConverterScreenState();
}

class _CvAtsConverterScreenState extends State<CvAtsConverterScreen> {
  final _service = CvAtsConverterService();

  File? _selectedFile;
  String? _selectedFileName;
  bool _isLoading = false;
  String _loadingMessage = '';
  CVData? _convertedCv;
  String? _errorMessage;
  String _targetLanguage = 'Original';

  int _step = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.convertToCvAts),
        centerTitle: true,
        actions: const [],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isLoading
            ? _buildLoadingView(theme, l10n)
            : _step == 0
                ? _buildUploadStep(theme, l10n)
                : _buildPreviewStep(theme, l10n),
      ),
    );
  }

  Widget _buildUploadStep(ThemeData theme, AppLocalizations l10n) {
    return SingleChildScrollView(
      key: const ValueKey('upload'),
      child: AppSection(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor.withValues(alpha: 0.15),
                    theme.primaryColor.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: theme.primaryColor.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Iconsax.magic_star,
                        size: 40, color: theme.primaryColor),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.convertToCvAts,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.aiConvertingDesc,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color
                          ?.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.howItWorks,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...[
              (
                '1',
                Iconsax.document_upload,
                l10n.uploadCvStep,
                l10n.photoOrPdf
              ),
              (
                '2',
                Iconsax.magic_star,
                l10n.geminiAnalysis,
                l10n.aiExtractedInfo
              ),
              (
                '3',
                Iconsax.document_text,
                l10n.autoPopulate,
                l10n.dataIntoForms
              ),
              ('4', Iconsax.edit, l10n.editAndExport, l10n.reviewEditExport),
            ].map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color:
                              theme.primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(item.$2,
                            size: 18, color: theme.primaryColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.$3,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)),
                            Text(item.$4,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: _pickFile,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    vertical: 40, horizontal: 24),
                decoration: BoxDecoration(
                  color: _selectedFile != null
                      ? theme.primaryColor.withValues(alpha: 0.05)
                      : theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedFile != null
                        ? theme.primaryColor
                        : theme.dividerColor,
                    width: _selectedFile != null ? 2 : 1.5,
                    style: _selectedFile != null
                        ? BorderStyle.solid
                        : BorderStyle.solid,
                  ),
                ),
                child: _selectedFile == null
                    ? Column(
                        children: [
                          Icon(Iconsax.document_upload,
                              size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          Text(
                            l10n.tapToSelectFile,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.supportedFormats,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.primaryColor
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _selectedFileName?.endsWith('.pdf') == true
                                  ? Iconsax.document_text
                                  : Iconsax.image,
                              color: theme.primaryColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedFileName ?? l10n.fileSelected,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.tapToChangeFile,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500]),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.check_circle,
                              color: theme.primaryColor),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.optionalTranslateCv,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildLangChip(l10n.originalLanguage, theme,
                    value: 'Original'),
                const SizedBox(width: 8),
                _buildLangChip(l10n.english, theme, value: 'English'),
                const SizedBox(width: 8),
                _buildLangChip(l10n.indonesian, theme,
                    value: 'Indonesian'),
              ],
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  _errorMessage!,
                  style:
                      const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _selectedFile == null ? null : _processFile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  l10n.startConversion,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewStep(ThemeData theme, AppLocalizations l10n) {
    if (_convertedCv == null) return const SizedBox.shrink();

    return Column(
      key: const ValueKey('preview'),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: Colors.green.withValues(alpha: 0.1),
          child: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.cvConvertedSuccess,
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              key: ValueKey(_convertedCv!.id),
              child: CvPreviewCard(cvData: _convertedCv!),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _saveAndEdit,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.edit),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saveOnly,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(l10n.save),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingView(ThemeData theme, AppLocalizations l10n) {
    return Center(
      key: const ValueKey('loading'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            l10n.analyzingCv,
            style: theme.textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 250,
            child: Text(
              _loadingMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'webp'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
          _selectedFileName = result.files.single.name;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() => _errorMessage =
          '${AppLocalizations.of(context)!.failedToSelectFile}: $e');
    }
  }

  Future<void> _processFile() async {
    if (_selectedFile == null) return;

    setState(() {
      _isLoading = true;
      _loadingMessage = AppLocalizations.of(context)!.analyzingCv;
    });

    try {
      _updateLoadingMessages();

      final targetLang = _targetLanguage == 'Original' ? null : _targetLanguage;
      final cvData = await _service.convertFromFile(_selectedFile!,
          targetLanguage: targetLang);

      if (mounted) {
        setState(() {
          _convertedCv = cvData;
          _step = 1;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          final currentL10n = AppLocalizations.of(context)!;
          _errorMessage = '${currentL10n.failedToProcessCv}: $e';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _updateLoadingMessages() async {
    final l10n = AppLocalizations.of(context)!;
    final messages = [
      l10n.extractingText,
      l10n.identifyingExperience,
      l10n.organizingEducation,
      l10n.groupingSkills,
      l10n.finishingUp,
    ];

    for (var msg in messages) {
      if (!_isLoading) break;
      await Future.delayed(const Duration(seconds: 2));
      if (mounted && _isLoading) {
        setState(() => _loadingMessage = msg);
      }
    }
  }

  void _saveAndEdit() {
    if (_convertedCv == null) return;

    final provider = context.read<CVBuilderProvider>();

    provider.updateCV(_convertedCv!);
    provider.saveCurrentCV();

    context.router.push(const CvBuilderStep1Route());
  }

  void _saveOnly() async {
    final l10n = AppLocalizations.of(context)!;
    if (_convertedCv == null) return;

    debugPrint('CV name: "${_convertedCv?.header.name}"');
    debugPrint('CV isValid: ${_convertedCv?.isValid}');

    final provider = context.read<CVBuilderProvider>();

    provider.updateCV(_convertedCv!);

    final success = await provider.saveCurrentCV();

    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? l10n.failedToSaveCv),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await provider.loadAllCVs();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.cvSavedToLibrary),
        backgroundColor: Colors.green,
      ),
    );

    context.router.replaceAll([const HomeRoute()]);
  }

  Widget _buildLangChip(String label, ThemeData theme, {String? value}) {
    final chipValue = value ?? label;
    final isSelected = _targetLanguage == chipValue;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _targetLanguage = chipValue);
      },
      selectedColor: theme.primaryColor.withValues(alpha: 0.2),
      labelStyle: TextStyle(
        color: isSelected ? theme.primaryColor : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
