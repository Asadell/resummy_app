import 'package:auto_route/auto_route.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_builder_step_layout.dart';
import 'package:resummy_app/features/cv_tools/presentation/utils/dynamic_cv_steps.dart';
import 'package:resummy_app/features/profile/presentation/providers/profile_provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';

@RoutePage()
class CvBuilderStep1Screen extends StatefulWidget {
  const CvBuilderStep1Screen({super.key});

  @override
  State<CvBuilderStep1Screen> createState() => _CvBuilderStep1ScreenState();
}

class _CvBuilderStep1ScreenState extends State<CvBuilderStep1Screen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _linkedinController;
  late TextEditingController _portfolioController;
  late TextEditingController _locationController;

  String? _fullPhoneNumber;

  @override
  void initState() {
    super.initState();
    final provider = context.read<CVBuilderProvider>();
    final cv = provider.currentCV;
    final profile = context.read<ProfileProvider>().profile;

    _nameController = TextEditingController(
      text: (cv?.name ?? '').isNotEmpty ? cv!.name : (profile?.fullName ?? ''),
    );
    _emailController = TextEditingController(
      text: (cv?.email ?? '').isNotEmpty ? cv!.email : (profile?.email ?? ''),
    );

    _phoneController = TextEditingController(text: cv?.phone);
    _fullPhoneNumber = cv?.phone;

    _linkedinController = TextEditingController(text: cv?.linkedin);
    _portfolioController = TextEditingController(text: cv?.portfolio);
    _locationController = TextEditingController(text: cv?.location);

    _nameController.addListener(_updatePreview);
    _emailController.addListener(_updatePreview);

    _linkedinController.addListener(_updatePreview);
    _portfolioController.addListener(_updatePreview);
    _locationController.addListener(_updatePreview);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _updatePreview();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _linkedinController.dispose();
    _portfolioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _updatePreview() {
    final provider = context.read<CVBuilderProvider>();
    provider.updatePersonalInfo(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _fullPhoneNumber ?? _phoneController.text.trim(),
      linkedin: _linkedinController.text.trim(),
      portfolio: _portfolioController.text.trim(),
      location: _locationController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CVBuilderStepLayout(
      title: l10n.cvBuilder,
      currentStep: 1,
      onBack: null,
      onNext: () {
        if (_formKey.currentState!.validate()) {
          final provider = context.read<CVBuilderProvider>();

          provider.updatePersonalInfo(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _fullPhoneNumber ?? _phoneController.text.trim(),
            linkedin: _linkedinController.text.trim(),
            portfolio: _portfolioController.text.trim(),
            location: _locationController.text.trim(),
          );

          provider.saveCurrentCV();
          final currentStep =
              DynamicCvSteps.getStepForSection(context, 'header');
          DynamicCvSteps.navigateToNextStep(context, currentStep);
        }
      },
      editContent: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSection(
              child: Column(
                spacing: AppSizes.sm,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Consumer<CVBuilderProvider>(
                      builder: (context, provider, _) {
                        final totalSteps =
                            DynamicCvSteps.getTotalSteps(provider.currentCV);
                        return Text(
                          l10n.stepHeader(1, totalSteps),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ),
                  Text(
                    l10n.personalInfoHeader,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    l10n.personalInfoDesc,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            AppSection(
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  spacing: AppSizes.md,
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: l10n.fullName,
                      isRequired: true,
                      hint: l10n.namePlaceholder,
                      context: context,
                    ),
                    _buildTextField(
                      controller: _emailController,
                      label: l10n.emailLabel,
                      isRequired: true,
                      hint: l10n.emailPlaceholder,
                      keyboardType: TextInputType.emailAddress,
                      context: context,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: AppSizes.xs,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: l10n.phoneNumber,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        IntlPhoneField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: l10n.phoneNumber,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                            counterText: '',
                          ),
                          initialCountryCode: 'ID',
                          disableLengthCheck: true,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (phone) {
                            _fullPhoneNumber = phone.completeNumber;

                            final provider = context.read<CVBuilderProvider>();
                            provider.updatePersonalInfo(
                              phone: _fullPhoneNumber!,
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              linkedin: _linkedinController.text.trim(),
                              portfolio: _portfolioController.text.trim(),
                              location: _locationController.text.trim(),
                            );
                          },
                          onCountryChanged: (country) {},
                          validator: (value) {
                            if (value == null || value.number.isEmpty) {
                              return l10n.requiredField;
                            }

                            if (value.number.startsWith('0')) {
                              return l10n.phoneNoLeadingZero;
                            }

                            if (value.number.length < 8) {
                              return l10n.phoneTooShort;
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    _buildTextField(
                      controller: _linkedinController,
                      label: l10n.linkedin,
                      isOptional: true,
                      hint: l10n.linkedinPlaceholder,
                      prefixIcon: Iconsax.link_1,
                      context: context,
                      maxLength: 100,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                    ),
                    _buildTextField(
                      controller: _portfolioController,
                      label: l10n.portfolio,
                      isOptional: true,
                      hint: l10n.portfolioPlaceholder,
                      prefixIcon: Iconsax.global,
                      context: context,
                      maxLength: 100,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                    ),
                    _buildTextField(
                      controller: _locationController,
                      label: l10n.location,
                      isRequired: true,
                      hint: l10n.locationPlaceholder,
                      prefixIcon: Iconsax.location,
                      context: context,
                      maxLength: 50,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required BuildContext context,
    bool isRequired = false,
    bool isOptional = false,
    String? hint,
    String? helperText,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.sm,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              if (isOptional)
                TextSpan(
                  text: ' ${l10n.optionalField}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
            ],
          ),
        ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: isRequired
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.requiredField;
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant
                  .withValues(alpha: 0.5),
            ),
            helperText: helperText,
            helperStyle:
                TextStyle(color: Theme.of(context).colorScheme.primary),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurfaceVariant)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.sm),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.sm),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSizes.sm),
              borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.md, vertical: AppSizes.sm),
            counterText: '',
          ),
        ),
      ],
    );
  }
}
