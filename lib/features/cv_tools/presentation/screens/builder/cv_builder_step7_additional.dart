import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
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
    _sections.keys.forEach((key) {
      if (currentAdditional.containsKey(key)) {
        _sections[key] = true;
        _controllers[key] = TextEditingController(text: currentAdditional[key]?.toString() ?? '');
      } else {
        _controllers[key] = TextEditingController();
      }
    });
  }

  @override
  void dispose() {
    _controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  void _save(CVBuilderProvider provider) {
    final Map<String, dynamic> additionalData = {};
    _sections.forEach((key, isEnabled) {
      if (isEnabled && _controllers[key]!.text.isNotEmpty) {
        additionalData[key] = _controllers[key]!.text.trim();
      }
    });
    provider.updateAdditionalSections(additionalData);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: Text(l10n.additionalHeader),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '7/7',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6B7280),
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
            value: 1.0,
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
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFF0EA5E9)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            l10n.stepHeader(7, 7),
                            style: const TextStyle(
                              color: Color(0xFF0EA5E9),
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
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Text(
                          l10n.additionalDesc,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
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
                                secondary: Icon(_getSectionIcon(key), color: const Color(0xFF0EA5E9)),
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
                                      fillColor: Colors.grey[50],
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
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
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
                    context.router.push(const CvBuilderPreviewRoute());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0EA5E9),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('${l10n.previewCV} →'),
                ),
              ),
            ],
          ),
        ),
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
