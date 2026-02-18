import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_builder_step_layout.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/features/cv_tools/presentation/utils/dynamic_cv_steps.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class CvBuilderStep7Screen extends StatefulWidget {
  const CvBuilderStep7Screen({super.key});

  @override
  State<CvBuilderStep7Screen> createState() => _CvBuilderStep7ScreenState();
}

class _CvBuilderStep7ScreenState extends State<CvBuilderStep7Screen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentStep =
        DynamicCvSteps.getStepForSection(context, 'certifications');

    return CVBuilderStepLayout(
      title: l10n.cvBuilder,
      currentStep: currentStep,
      onBack: () {
        DynamicCvSteps.navigateToPreviousStep(context, currentStep);
      },
      onNext: () {
        final provider = context.read<CVBuilderProvider>();
        provider.saveCurrentCV();
        final currentStep =
            DynamicCvSteps.getStepForSection(context, 'certifications');
        DynamicCvSteps.navigateToNextStep(context, currentStep);
      },
      editContent: Consumer<CVBuilderProvider>(
        builder: (context, provider, child) {
          final certList = provider.currentCV?.certifications ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Consumer<CVBuilderProvider>(
                    builder: (context, provider, _) {
                      final currentStep = DynamicCvSteps.getStepForSection(
                          context, 'certifications');
                      final totalSteps =
                          DynamicCvSteps.getTotalSteps(provider.currentCV);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          l10n.stepHeader(currentStep, totalSteps),
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    l10n.certificationHeader,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    l10n.certificationDesc,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color
                              ?.withValues(alpha: 0.7),
                        ),
                  ),
                ),
                const SizedBox(height: 24),
                if (certList.isEmpty)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Iconsax.verify,
                            size: 48,
                            color: Color(0xFF9CA3AF),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noCertificationData,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.skipStepPrompt,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (certList.isNotEmpty) ...[
                  ReorderableListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: certList.length,
                    onReorder: (oldIndex, newIndex) {
                      provider.reorderCertifications(oldIndex, newIndex);
                    },
                    itemBuilder: (context, index) {
                      final cert = certList[index];
                      final date =
                          '${cert.issueDate.month}/${cert.issueDate.year}';

                      return Card(
                        key: ValueKey(cert.id),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: const Icon(Icons.drag_indicator),
                          title: Text(
                            cert.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text('${cert.issuingOrganization} • $date'),
                              if (cert.credentialId != null &&
                                  cert.credentialId!.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                  Text(
                                    '${l10n.credentialIdLabel}: ${cert.credentialId}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Iconsax.edit, size: 20),
                                onPressed: () =>
                                    _editCertification(cert, index),
                              ),
                              IconButton(
                                icon: const Icon(Iconsax.trash,
                                    size: 20, color: Colors.red),
                                onPressed: () =>
                                    provider.removeCertification(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                _buildInlineForm(context, provider),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _organizationController = TextEditingController();
  final _credentialIdController = TextEditingController();
  final _credentialUrlController = TextEditingController();
  DateTime _issueDate = DateTime.now();
  DateTime? _expirationDate;
  bool _doesNotExpire = false;
  int? _editingIndex;
  bool _showValidation = false;

  String? _validateIssueDate(AppLocalizations l10n) {
    if (_issueDate.isAfter(DateTime.now())) {
      return l10n.yearTooHigh;
    }
    return null;
  }

  String? _validateExpirationDate(AppLocalizations l10n) {
    if (_doesNotExpire) return null;
    if (_expirationDate == null) return l10n.requiredField;
    if (_expirationDate!.isBefore(_issueDate)) {
      return l10n.dateStartAfterEnd;
    }
    return null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _organizationController.dispose();
    _credentialIdController.dispose();
    _credentialUrlController.dispose();
    super.dispose();
  }

  void _editCertification(Certification cert, int index) {
    setState(() {
      _editingIndex = index;
      _nameController.text = cert.name;
      _organizationController.text = cert.issuingOrganization;
      _credentialIdController.text = cert.credentialId ?? '';
      _credentialUrlController.text = cert.credentialUrl ?? '';
      _issueDate = cert.issueDate;
      _expirationDate = cert.expirationDate;
      _doesNotExpire = cert.doesNotExpire;
    });
  }

  void _resetForm() {
    setState(() {
      _editingIndex = null;
      _nameController.clear();
      _organizationController.clear();
      _credentialIdController.clear();
      _credentialUrlController.clear();
      _issueDate = DateTime.now();
      _expirationDate = null;
      _doesNotExpire = false;
      _showValidation = false;
    });
  }

  void _saveForm(CVBuilderProvider provider) {
    setState(() => _showValidation = true);
    if (_formKey.currentState!.validate()) {
      if (!_doesNotExpire &&
          (_expirationDate == null || _expirationDate!.isBefore(_issueDate))) {
        return;
      }
      if (_issueDate.isAfter(DateTime.now())) {
        return;
      }
      final cert = Certification(
        id: _editingIndex != null
            ? provider.currentCV!.certifications[_editingIndex!].id
            : const Uuid().v4(),
        name: _nameController.text.trim(),
        issuingOrganization: _organizationController.text.trim(),
        issueDate: _issueDate,
        expirationDate: _doesNotExpire ? null : _expirationDate,
        doesNotExpire: _doesNotExpire,
        credentialId: _credentialIdController.text.trim().isNotEmpty
            ? _credentialIdController.text.trim()
            : null,
        credentialUrl: _credentialUrlController.text.trim().isNotEmpty
            ? _credentialUrlController.text.trim()
            : null,
      );

      if (_editingIndex != null) {
        provider.updateCertification(_editingIndex!, cert);
      } else {
        provider.addCertification(cert);
      }

      _resetForm();
    }
  }

  Future<void> _selectDate(BuildContext context, bool isIssueDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          isIssueDate ? _issueDate : (_expirationDate ?? DateTime.now()),
      firstDate: DateTime(1980),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null) {
      setState(() {
        if (isIssueDate) {
          _issueDate = picked;
        } else {
          _expirationDate = picked;
        }
      });
    }
  }

  Widget _buildInlineForm(BuildContext context, CVBuilderProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = _editingIndex != null;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        autovalidateMode: _showValidation
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isEditing ? l10n.editCertification : l10n.addCertification,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (isEditing)
                  TextButton.icon(
                    onPressed: _resetForm,
                    icon: const Icon(Icons.close),
                    label: Text(l10n.cancel),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: '${l10n.certificationName} *',
                hintText: l10n.certificationPlaceholder,
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              validator: (v) => v?.isEmpty == true ? l10n.requiredField : null,
              maxLength: 50,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _organizationController,
              decoration: InputDecoration(
                labelText: '${l10n.issuingOrganization} *',
                hintText: l10n.issuingOrgPlaceholder,
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              validator: (v) => v?.isEmpty == true ? l10n.requiredField : null,
              maxLength: 50,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context, true),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: '${l10n.issueDate} *',
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.calendar_today, size: 16),
                        errorText:
                            _showValidation ? _validateIssueDate(l10n) : null,
                      ),
                      child: Text(
                          '${_issueDate.day}/${_issueDate.month}/${_issueDate.year}'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: _doesNotExpire
                        ? null
                        : () => _selectDate(context, false),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.expirationDate,
                        border: const OutlineInputBorder(),
                        suffixIcon: const Icon(Icons.calendar_today, size: 16),
                        enabled: !_doesNotExpire,
                        errorText: _showValidation
                            ? _validateExpirationDate(l10n)
                            : null,
                      ),
                      child: Text(
                        _doesNotExpire
                            ? '-'
                            : (_expirationDate != null
                                ? '${_expirationDate!.day}/${_expirationDate!.month}/${_expirationDate!.year}'
                                : l10n.selectDate),
                        style: TextStyle(
                          color: _doesNotExpire
                              ? Theme.of(context).disabledColor
                              : Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            CheckboxListTile(
              value: _doesNotExpire,
              onChanged: (val) {
                setState(() {
                  _doesNotExpire = val ?? false;
                  if (_doesNotExpire) {
                    _expirationDate = null;
                  }
                });
              },
              title: Text(l10n.doesNotExpire),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _credentialIdController,
              decoration: InputDecoration(
                labelText: l10n.credentialId,
                border: const OutlineInputBorder(),
                counterText: '',
              ),
              maxLength: 50,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _credentialUrlController,
              decoration: InputDecoration(
                labelText: l10n.credentialUrl,
                border: const OutlineInputBorder(),
                helperText: l10n.credentialUrlHelper,
                prefixIcon: const Icon(Iconsax.link_1),
                counterText: '',
              ),
              keyboardType: TextInputType.url,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
              maxLength: 100,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _saveForm(provider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(isEditing ? l10n.save : l10n.addCertification),
            ),
          ],
        ),
      ),
    );
  }
}
