import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_data.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

@RoutePage()
class CvBuilderStep4Screen extends StatefulWidget {
  const CvBuilderStep4Screen({super.key});

  @override
  State<CvBuilderStep4Screen> createState() => _CvBuilderStep4ScreenState();
}

class _CvBuilderStep4ScreenState extends State<CvBuilderStep4Screen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.certificationHeader),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '4/7',
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
            value: 4 / 7,
            backgroundColor: const Color(0xFFE5E7EB),
            color: const Color(0xFF0EA5E9),
            minHeight: 4,
          ),
          
          Expanded(
            child: Consumer<CVBuilderProvider>(
              builder: (context, provider, child) {
                final certList = provider.currentCV?.certifications ?? [];
                
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
                            l10n.stepHeader(4, 7),
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
                            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Empty State
                      if (certList.isEmpty)
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Theme.of(context).dividerColor),
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
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                                const SizedBox(height: 24),
                                OutlinedButton.icon(
                                  onPressed: () => _showCertForm(context),
                                  icon: const Icon(Iconsax.add),
                                  label: Text(l10n.addCertification),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                      // List of Certifications
                      if (certList.isNotEmpty) ...[
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: certList.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final cert = certList[index];
                            final date = '${cert.issueDate.month}/${cert.issueDate.year}';
                            
                            return Card(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                title: Text(
                                  cert.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text('${cert.issuingOrganization} • $date'),
                                    if (cert.credentialId != null && cert.credentialId!.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'ID: ${cert.credentialId}',
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
                                      onPressed: () => _showCertForm(context, cert: cert, index: index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Iconsax.trash, size: 20, color: Colors.red),
                                      onPressed: () => provider.removeCertification(index),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        
                        OutlinedButton.icon(
                          onPressed: () => _showCertForm(context),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            side: BorderSide(color: Theme.of(context).colorScheme.primary),
                          ),
                          icon: const Icon(Iconsax.add),
                          label: Text(l10n.addAnotherCertification),
                        ),
                      ],
                      
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
                    context.router.push(const CvBuilderStep5Route());
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

  void _showCertForm(BuildContext context, {Certification? cert, int? index}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CertificationForm(cert: cert, index: index),
    );
  }
}

class _CertificationForm extends StatefulWidget {
  final Certification? cert;
  final int? index;

  const _CertificationForm({this.cert, this.index});

  @override
  State<_CertificationForm> createState() => _CertificationFormState();
}

class _CertificationFormState extends State<_CertificationForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _organizationController;
  late TextEditingController _credentialIdController;
  late TextEditingController _credentialUrlController;
  DateTime _issueDate = DateTime.now();
  DateTime? _expirationDate;
  bool _doesNotExpire = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.cert?.name);
    _organizationController = TextEditingController(text: widget.cert?.issuingOrganization);
    _credentialIdController = TextEditingController(text: widget.cert?.credentialId);
    _credentialUrlController = TextEditingController(text: widget.cert?.credentialUrl);
    
    if (widget.cert != null) {
      _issueDate = widget.cert!.issueDate;
      _expirationDate = widget.cert!.expirationDate;
      _doesNotExpire = widget.cert!.doesNotExpire;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _organizationController.dispose();
    _credentialIdController.dispose();
    _credentialUrlController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<CVBuilderProvider>();
      final cert = Certification(
        id: widget.cert?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        issuingOrganization: _organizationController.text.trim(),
        issueDate: _issueDate,
        expirationDate: _doesNotExpire ? null : _expirationDate,
        doesNotExpire: _doesNotExpire,
        credentialId: _credentialIdController.text.trim().isNotEmpty ? _credentialIdController.text.trim() : null,
        credentialUrl: _credentialUrlController.text.trim().isNotEmpty ? _credentialUrlController.text.trim() : null,
      );

      if (widget.index != null) {
        provider.updateCertification(widget.index!, cert);
      } else {
        provider.addCertification(cert);
      }
      
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context, bool isIssueDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isIssueDate ? _issueDate : (_expirationDate ?? DateTime.now()),
      firstDate: DateTime(1980),
      lastDate: DateTime.now().add(const Duration(days: 3650)), // Allow future exp dates
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      decoration: const BoxDecoration(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.cert != null ? l10n.editCertification : l10n.addCertification,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: '${l10n.certificationName} *',
                    hintText: 'Google Cloud Associate',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) => v?.isEmpty == true ? l10n.requiredField : null,
                ),
                const SizedBox(height: 16),
                
                // Organization
                TextFormField(
                  controller: _organizationController,
                  decoration: InputDecoration(
                    labelText: '${l10n.issuingOrganization} *',
                    hintText: 'Google',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) => v?.isEmpty == true ? l10n.requiredField : null,
                ),
                const SizedBox(height: 16),
                
                // Dates
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
                          ),
                          child: Text('${_issueDate.day}/${_issueDate.month}/${_issueDate.year}'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: _doesNotExpire ? null : () => _selectDate(context, false),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: l10n.expirationDate,
                            border: const OutlineInputBorder(),
                            suffixIcon: const Icon(Icons.calendar_today, size: 16),
                            enabled: !_doesNotExpire,
                          ),
                          child: Text(
                            _doesNotExpire 
                                ? '-' 
                                : (_expirationDate != null 
                                    ? '${_expirationDate!.day}/${_expirationDate!.month}/${_expirationDate!.year}'
                                    : l10n.selectDate),
                            style: TextStyle(
                              color: _doesNotExpire ? Theme.of(context).disabledColor : Theme.of(context).textTheme.bodyMedium?.color,
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
                
                // Credential ID
                TextFormField(
                  controller: _credentialIdController,
                  decoration: InputDecoration(
                    labelText: l10n.credentialId,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Credential URL
                TextFormField(
                  controller: _credentialUrlController,
                  decoration: InputDecoration(
                    labelText: l10n.credentialUrl,
                    border: const OutlineInputBorder(),
                    helperText: l10n.credentialUrlHelper,
                    prefixIcon: const Icon(Iconsax.link_1),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(l10n.save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
