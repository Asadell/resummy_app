import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class OnboardingStep3Screen extends StatefulWidget {
  final String fullName;
  final String? workStatus;

  const OnboardingStep3Screen({
    super.key,
    required this.fullName,
    this.workStatus,
  });

  @override
  State<OnboardingStep3Screen> createState() => _OnboardingStep3ScreenState();
}

class _OnboardingStep3ScreenState extends State<OnboardingStep3Screen> {
  final _roleController = TextEditingController();
  final _focusNode = FocusNode();
  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  static const List<String> _roleSuggestions = [
    'Software Engineer',
    'Frontend Developer',
    'Backend Developer',
    'Full Stack Developer',
    'Mobile Developer',
    'Android Developer',
    'iOS Developer',
    'Flutter Developer',
    'React Developer',
    'DevOps Engineer',
    'Data Scientist',
    'Data Analyst',
    'Data Engineer',
    'Machine Learning Engineer',
    'AI Engineer',
    'Product Manager',
    'Project Manager',
    'UI/UX Designer',
    'Graphic Designer',
    'Digital Marketing',
    'Content Writer',
    'Business Analyst',
    'QA Engineer',
    'System Administrator',
    'Network Engineer',
    'Cyber Security Analyst',
    'Cloud Engineer',
    'Database Administrator',
    'Technical Writer',
    'Scrum Master',
  ];

  @override
  void initState() {
    super.initState();
    _roleController.addListener(_onTextChanged);
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _roleController.text.isNotEmpty) {
        _filterSuggestions(_roleController.text);
      }
    });
  }

  @override
  void dispose() {
    _roleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _filterSuggestions(_roleController.text);
  }

  void _filterSuggestions(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredSuggestions = [];
        _showSuggestions = false;
      });
      return;
    }

    final filtered = _roleSuggestions
        .where((role) => role.toLowerCase().contains(query.toLowerCase()))
        .take(5)
        .toList();

    setState(() {
      _filteredSuggestions = filtered;
      _showSuggestions = filtered.isNotEmpty;
    });
  }

  void _selectSuggestion(String suggestion) {
    _roleController.text = suggestion;
    setState(() {
      _showSuggestions = false;
    });
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.stepProgress(3, 4)),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.router.maybePop(),
        ),
        actions: [
          TextButton(
            onPressed: () => _skipToConfirmation(context),
            child: Text(l10n.skip),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Iconsax.medal_star,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.whatsYourTargetRole,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _roleController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  labelText: l10n.targetRole,
                  hintText: l10n.targetRoleHint,
                  prefixIcon: const Icon(Iconsax.briefcase),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              if (_showSuggestions) ...[
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _filteredSuggestions.map((suggestion) {
                      return InkWell(
                        onTap: () => _selectSuggestion(suggestion),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.briefcase,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                suggestion,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Iconsax.lamp_on,
                    size: 16,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.typeToSeeSuggestions,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                onPressed: () {
                  context.router.push(OnboardingStep4Route(
                    fullName: widget.fullName,
                    workStatus: widget.workStatus,
                    targetRole: _roleController.text.trim().isNotEmpty
                        ? _roleController.text.trim()
                        : null,
                  ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.next),
                    const SizedBox(width: 8),
                    const Icon(Iconsax.arrow_right),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _skipToConfirmation(BuildContext context) {
    context.router.push(OnboardingConfirmationRoute(
      fullName: widget.fullName,
      workStatus: widget.workStatus,
      targetRole: _roleController.text.trim().isNotEmpty
          ? _roleController.text.trim()
          : null,
      careerGoal: null,
    ));
  }
}
