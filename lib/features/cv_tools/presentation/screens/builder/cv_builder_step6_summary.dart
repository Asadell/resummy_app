import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class CvBuilderStep6Screen extends StatefulWidget {
  const CvBuilderStep6Screen({super.key});

  @override
  State<CvBuilderStep6Screen> createState() => _CvBuilderStep6ScreenState();
}

class _CvBuilderStep6ScreenState extends State<CvBuilderStep6Screen> {
  late TextEditingController _summaryController;

  @override
  void initState() {
    super.initState();
    final provider = context.read<CVBuilderProvider>();
    _summaryController = TextEditingController(text: provider.currentCV?.summary);
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  void _save(CVBuilderProvider provider) {
    provider.updateSummary(_summaryController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.summaryHeader),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '6/7',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: 6 / 7,
            backgroundColor: const Color(0xFFE5E7EB),
            color: const Color(0xFF0EA5E9),
            minHeight: 4,
          ),
          
          Expanded(
            child: Consumer<CVBuilderProvider>(
              builder: (context, provider, child) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Step Header
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            border: Border.all(color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            l10n.stepHeader(6, 7),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(
                          l10n.summaryHeader,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          l10n.summaryDesc,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // AI Generator Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [const Color(0xFF0EA5E9).withValues(alpha: 0.1), const Color(0xFF0EA5E9).withValues(alpha: 0.05)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF0EA5E9).withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          children: [
                            Row(
                            Row(
                              children: [
                                Icon(Iconsax.magic_star, color: Theme.of(context).primaryColor),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.aiInspirationTitle,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.aiInspirationDesc,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.featureComingSoon)),
                                  );
                                },
                                icon: const Icon(Iconsax.hierarchy, size: 18),
                                label: Text(l10n.generateWithAi),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).cardColor,
                                  foregroundColor: Theme.of(context).primaryColor,
                                  shadowColor: Colors.transparent,
                                  side: BorderSide(color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        l10n.summaryLabel,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _summaryController,
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: l10n.summaryHint,
                          border: const OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                        onChanged: (value) => _save(provider),
                      ),
                       const SizedBox(height: 8),
                      Text(
                        l10n.summaryTip,
                        style: const TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 12,
                        ),
                      ),
                      
                      const SizedBox(height: 80),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, -4),
              blurRadius: 16,
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => context.router.maybePop(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(l10n.goBack),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Save and next
                    context.read<CVBuilderProvider>().saveCurrentCV();
                    context.router.push(const CvBuilderStep7Route());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('${l10n.next} →'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
