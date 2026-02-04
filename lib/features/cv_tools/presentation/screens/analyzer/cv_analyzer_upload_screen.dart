import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class CvAnalyzerUploadScreen extends StatefulWidget {
  const CvAnalyzerUploadScreen({super.key});

  @override
  State<CvAnalyzerUploadScreen> createState() => _CvAnalyzerUploadScreenState();
}

class _CvAnalyzerUploadScreenState extends State<CvAnalyzerUploadScreen> {
  PlatformFile? _selectedFile;

  void _pickCvFile(BuildContext context) async {
    if (mounted) {
      try {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx'],
        );

        if (result != null && result.files.isNotEmpty) {
          setState(() => _selectedFile = result.files.first);
        }
      } catch (e) {
        print('File pick error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong, please try again.')),
        );
      }
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
          onPressed: () => context.router.push(const CvToolsHubRoute()),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _selectedFile != null
                ? _renderFileInfo(context)
                : _renderFileInput(l10n, context),
          ),
        ),
      ),
    );
  }

  List<Widget> _renderFileInput(AppLocalizations l10n, BuildContext context) {
    return [
      Text(
        l10n.chooseCvSource,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 32),
      OutlinedButton(
        onPressed: () => _pickCvFile(context),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: 32,
            horizontal: 16,
          ),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            const Icon(Iconsax.document_upload, size: 48),
            const SizedBox(height: 16),
            Text(
              l10n.uploadNewCv,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.uploadCvFileHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      const SizedBox(height: 24),
      Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              l10n.or,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: Divider(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
      const SizedBox(height: 24),
      ElevatedButton(
        onPressed: () => _showCvListBottomSheet(context),
        child: Text(l10n.useExistingCv),
      ),
    ];
  }

  List<Widget> _renderFileInfo(BuildContext context) {
    return [
      Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(
          minHeight: 200,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline,
            width: 1,
          ),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.document_text, size: 64),
            const SizedBox(height: 24),
            Text(
              _selectedFile!.name,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${(_selectedFile!.size / (1024 * 1024)).toStringAsFixed(2)} MB',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      const SizedBox(height: 32),
      Row(
        spacing: 16,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => setState(() => _selectedFile = null),
              child: Text('Batal'),
            ),
          ),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              child: Text('Lanjut'),
            ),
          ),
        ],
      )
    ];
  }

  void _showCvListBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.savedCvs,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: 5, // Placeholder count
                itemBuilder: (context, index) {
                  final l10n = AppLocalizations.of(context)!;
                  final now = DateTime.now();
                  final dateStr = '${now.day}/${now.month}/${now.year}';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Iconsax.document_text),
                      title: Text(l10n.cvNumber(index + 1)),
                      subtitle: Text(l10n.createdOnDate(dateStr)),
                      trailing: const Icon(Iconsax.arrow_right_3),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
