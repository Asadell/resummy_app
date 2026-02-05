import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/providers/auth_provider.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_analyzer_provider.dart';

@RoutePage()
class CvAnalyzerInputScreen extends StatefulWidget {
  const CvAnalyzerInputScreen({super.key});

  @override
  State<CvAnalyzerInputScreen> createState() => _CvAnalyzerInputScreenState();
}

class _CvAnalyzerInputScreenState extends State<CvAnalyzerInputScreen> {
  final _positionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserJobPosition();
  }

  @override
  void dispose() {
    _positionController.dispose();
    super.dispose();
  }

  Future<void> _loadUserJobPosition() async {
    final authProvider = context.read<AuthProvider>();
    final cvAnalyzerProvider = context.read<CvAnalyzerProvider>();

    final userId = authProvider.user!.uid;
    final jobPosition = await cvAnalyzerProvider.getUserJobPosition(userId);

    if (mounted) {
      _positionController.text = jobPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cvAnalyzer),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.router.push(const CvAnalyzerUploadRoute()),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _renderFileCard(context),
              const SizedBox(height: 24),
              Text(
                l10n.appliedPosition,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _positionController,
                decoration: InputDecoration(
                  hintText: l10n.optional,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: () =>
                    context.router.push(const CvAnalyzerLoadingRoute()),
                child: Text(l10n.startAnalysis),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Card _renderFileCard(BuildContext context) {
    final fileInfo = context.watch<CvAnalyzerProvider>().selectedFileInfo;
    final l10n = AppLocalizations.of(context)!;

    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(
              Icons.insert_drive_file,
              size: 40,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileInfo != null ? fileInfo.name : l10n.noFileSelected,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  IntrinsicHeight(
                    child: Row(
                      spacing: 8,
                      children: [
                        Text(
                          fileInfo != null
                              ? fileInfo.extension.toUpperCase()
                              : '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        VerticalDivider(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        Text(
                          fileInfo != null ? '${fileInfo.size} MB' : '',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
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
}
