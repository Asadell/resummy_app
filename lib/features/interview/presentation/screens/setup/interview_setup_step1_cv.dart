import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/utils/pdf_utils.dart';

import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/theme/app_colors.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/features/interview/presentation/providers/interview_provider.dart';

@RoutePage()
class InterviewSetupStep1Screen extends StatefulWidget {
  const InterviewSetupStep1Screen({super.key});

  @override
  State<InterviewSetupStep1Screen> createState() =>
      _InterviewSetupStep1ScreenState();
}

class _InterviewSetupStep1ScreenState extends State<InterviewSetupStep1Screen> {
  int _selectedCvIndex = 0;
  String? _uploadedCvName;
  String? _uploadedCvText;

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
            _selectedCvIndex = 2;
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Iconsax.microphone_2,
                color: Theme.of(context).colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(l10n.aiInterviewSimulator),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_1),
          onPressed: () => context.router.push(const InterviewPrepRoute()),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black.withValues(alpha: 0.05)
                          : Colors.transparent,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      Iconsax.microphone_2,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.aiInterviewSimulator,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.setupStep1Desc,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Iconsax.document_text,
                            color: Theme.of(context).colorScheme.primary,
                            size: 20),
                        const SizedBox(width: 8),
                        Text(
                          l10n.formatInterview,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.5,
                      children: [
                        _buildInfoChip(context, l10n.durationAprox),
                        _buildInfoChip(context, l10n.questionsCount),
                        _buildInfoChip(context, l10n.languageOption),
                        _buildInfoChip(context, l10n.methodStar),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        l10n.step1SelectCv,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    ...[0, 1].map((i) => Padding(
                          padding: EdgeInsets.only(bottom: i == 1 ? 12 : 0),
                          child: _buildCvItem(
                            context,
                            index: i,
                            filename: i == 0
                                ? 'CV_Software_Engineer.pdf'
                                : 'CV_Product_Manager.pdf',
                            score: i == 0 ? 78 : 85,
                          ),
                        )),
                    if (_uploadedCvName != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildCvItem(
                          context,
                          index: 2,
                          filename: _uploadedCvName!,
                          score: 0,
                          isUploaded: true,
                        ),
                      ),
                    _buildUploadOption(context),
                  ],
                ),
              ),
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
          child: ElevatedButton(
            onPressed: () {
              final provider = context.read<InterviewProvider>();
              String cvText = "";
              String cvName = "";

              if (_selectedCvIndex == 2 && _uploadedCvText != null) {
                cvText = _uploadedCvText!;
                cvName = _uploadedCvName ?? "Uploaded CV.pdf";
              } else if (_selectedCvIndex == 0) {
                cvText =
                    "Experienced Flutter Developer with 5 years of experience in mobile app development. Proficient in Dart, BLoC pattern, and Clean Architecture. Strong background in integrating REST APIs and Firebase.";
                cvName = "CV_Software_Engineer.pdf";
              } else {
                cvText =
                    "Product Manager with 3 years experience in Fintech. Skilled in Agile methodology, user research, and roadmap planning. Experience leading cross-functional teams.";
                cvName = "CV_Product_Manager.pdf";
              }

              provider.updateCvText(cvText);
              provider.updateCvFileName(cvName);

              context.router.push(const InterviewSetupStep2Route());
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
            ),
            child: Text('${l10n.continueText} →'),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildCvItem(
    BuildContext context, {
    required int index,
    required String filename,
    required int score,
    bool isUploaded = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final isSelected = _selectedCvIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedCvIndex = index),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).cardTheme.color,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerTheme.color!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Iconsax.record_circle : Iconsax.stop_circle,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Icon(isUploaded ? Iconsax.document_upload : Iconsax.document_1,
                color: isUploaded
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.primary,
                size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    filename,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isUploaded)
                    Text(
                      l10n.uploadedFromDevice,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontSize: 10,
                          ),
                    ),
                ],
              ),
            ),
            if (!isUploaded)
              Text(
                l10n.score(score),
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      onTap: _pickCvFile,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary,
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.document_upload,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              l10n.uploadNewCv,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
