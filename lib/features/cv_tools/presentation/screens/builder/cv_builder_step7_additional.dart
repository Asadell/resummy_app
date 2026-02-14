import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_builder_step_layout.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class CvBuilderStep7Screen extends StatefulWidget {
  const CvBuilderStep7Screen({super.key});

  @override
  State<CvBuilderStep7Screen> createState() => _CvBuilderStep7ScreenState();
}

class _CvBuilderStep7ScreenState extends State<CvBuilderStep7Screen> {
  final Map<String, bool> _sections = {
    'Languages': false,
    'Volunteer': false,
    'References': false,
    'Interests': false,
  };
  
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    final provider = context.read<CVBuilderProvider>();
    final currentAdditional = provider.currentCV?.additionalSections ?? {};
    
    // Initialize state from existing data
    for (final key in _sections.keys) {
      if (currentAdditional.containsKey(key)) {
        _sections[key] = true;
        _controllers[key] = TextEditingController(text: currentAdditional[key]?.toString() ?? '');
      } else {
        _controllers[key] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _save(CVBuilderProvider provider) {
    final Map<String, dynamic> additionalData = {};
    for (final entry in _sections.entries) {
      final key = entry.key;
      final isEnabled = entry.value;
      if (isEnabled && _controllers[key]!.text.isNotEmpty) {
        additionalData[key] = _controllers[key]!.text.trim();
      }
    }
    provider.updateAdditionalSections(additionalData);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CVBuilderStepLayout(
      title: l10n.cvBuilder,
      currentStep: 7,
      totalSteps: 7,
      onBack: () => context.router.maybePop(),
      onNext: () {
        context.read<CVBuilderProvider>().saveCurrentCV();
        context.router.push(const CvBuilderPreviewRoute());
      },
      nextLabel: l10n.previewCV,
      editContent: Consumer<CVBuilderProvider>(
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
                      l10n.stepHeader(7, 7),
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
                    l10n.additionalHeader,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    l10n.additionalDesc,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Sections List
                ..._sections.keys.map((key) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: Text(
                            _getLocalizedSectionName(context, key),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          value: _sections[key],
                          onChanged: (val) {
                            setState(() {
                              _sections[key] = val ?? false;
                              if (!_sections[key]!) {
                                _controllers[key]?.clear();
                                _save(provider);
                              }
                            });
                          },
                          secondary: Icon(_getSectionIcon(key), color: Theme.of(context).primaryColor),
                        ),
                        if (_sections[key]!)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: TextField(
                              controller: _controllers[key],
                              maxLines: 3,
                              decoration: InputDecoration(
                                hintText: _getSectionHint(context, key),
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor: Theme.of(context).canvasColor,
                              ),
                              onChanged: (_) => _save(provider),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
                
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getLocalizedSectionName(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'Languages': return l10n.sectionLanguages;
      case 'Volunteer': return l10n.sectionVolunteer;
      case 'References': return l10n.sectionReferences;
      case 'Interests': return l10n.sectionInterests;
      default: return key;
    }
  }

  String _getSectionHint(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'Languages': return l10n.hintLanguages;
      case 'Volunteer': return l10n.hintVolunteer;
      case 'References': return l10n.hintReferences;
      case 'Interests': return l10n.hintInterests;
      default: return '';
    }
  }

  IconData _getSectionIcon(String key) {
    switch (key) {
      case 'Languages': return Iconsax.translate;
      case 'Volunteer': return Iconsax.heart;
      case 'References': return Iconsax.people;
      case 'Interests': return Iconsax.music_play;
      default: return Iconsax.add_circle;
    }
  }
}
