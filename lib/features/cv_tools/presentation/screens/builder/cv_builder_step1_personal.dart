import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_builder_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_preview_card.dart';

import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class CvBuilderStep1Screen extends StatefulWidget {
  const CvBuilderStep1Screen({super.key});

  @override
  State<CvBuilderStep1Screen> createState() => _CvBuilderStep1ScreenState();
}

class _CvBuilderStep1ScreenState extends State<CvBuilderStep1Screen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _linkedinController;
  late TextEditingController _portfolioController;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    final provider = context.read<CVBuilderProvider>();
    final cv = provider.currentCV;
    
    _nameController = TextEditingController(text: cv?.name);
    _emailController = TextEditingController(text: cv?.email);
    _phoneController = TextEditingController(text: cv?.phone);
    _linkedinController = TextEditingController(text: cv?.linkedin);
    _portfolioController = TextEditingController(text: cv?.portfolio);
    _locationController = TextEditingController(text: cv?.location);
    
    // Add listeners for real-time preview updates
    _nameController.addListener(_updatePreview);
    _emailController.addListener(_updatePreview);
    _phoneController.addListener(_updatePreview);
    _linkedinController.addListener(_updatePreview);
    _portfolioController.addListener(_updatePreview);
    _locationController.addListener(_updatePreview);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
      phone: _phoneController.text.trim(),
      linkedin: _linkedinController.text.trim(),
      portfolio: _portfolioController.text.trim(),
      location: _locationController.text.trim(),
    );
  }

  void _saveAndNext() {
    if (_formKey.currentState!.validate()) {
      final provider = context.read<CVBuilderProvider>();
      
      provider.updatePersonalInfo(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        linkedin: _linkedinController.text.trim(),
        portfolio: _portfolioController.text.trim(),
        location: _locationController.text.trim(),
      );
      
      // Auto-save progress
      provider.saveCurrentCV();
      
      // Navigate to next step
      context.router.push(const CvBuilderStep2Route());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.cvBuilder),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '1/7',
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
            value: 1 / 7,
            backgroundColor: const Color(0xFFE5E7EB),
            color: const Color(0xFF0EA5E9),
            minHeight: 4,
          ),
          
          // Tab Bar
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF0EA5E9),
              indicatorWeight: 3,
              labelColor: const Color(0xFF0EA5E9),
              unselectedLabelColor: const Color(0xFF6B7280),
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              tabs: [
                Tab(text: l10n.edit),
                Tab(text: l10n.previewCV),
              ],
            ),
          ),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Edit Tab
                _buildEditContent(),
                // Preview Tab
                _buildPreviewContent(),
              ],
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
          child: ElevatedButton(
            onPressed: _saveAndNext,
            onPressed: _saveAndNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '${l10n.next} →',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildEditContent() {
    final l10n = AppLocalizations.of(context)!;
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
                l10n.stepHeader(1, 7),
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
              l10n.personalInfoHeader,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              l10n.personalInfoDesc,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Form Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Full Name (Required)
                    _buildTextField(
                      controller: _nameController,
                      label: l10n.fullName,
                      isRequired: true,
                      hint: 'John Doe',
                      helperText: l10n.autoFillHint,
                      context: context,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Email (Required)
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      isRequired: true,
                      hint: 'john@example.com',
                      keyboardType: TextInputType.emailAddress,
                      context: context,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Phone (Required)
                    _buildTextField(
                      controller: _phoneController,
                      label: l10n.phoneNumber,
                      isRequired: true,
                      hint: '+62 812-3456-7890',
                      keyboardType: TextInputType.phone,
                      prefixIcon: Iconsax.call,
                      context: context,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // LinkedIn (Optional)
                    _buildTextField(
                      controller: _linkedinController,
                      label: l10n.linkedin,
                      isOptional: true,
                      hint: 'linkedin.com/in/john',
                      prefixIcon: Iconsax.link_1,
                      context: context,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Portfolio (Optional)
                    _buildTextField(
                      controller: _portfolioController,
                      label: l10n.portfolio,
                      isOptional: true,
                      hint: 'github.com/johndoe',
                      prefixIcon: Iconsax.global,
                      context: context,
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Location (Required)
                    _buildTextField(
                      controller: _locationController,
                      label: l10n.location,
                      isRequired: true,
                      hint: 'Jakarta, Indonesia',
                      prefixIcon: Iconsax.location,
                      context: context,
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 80), // Bottom padding for sticky button
        ],
      ),
    );
  }
  
  Widget _buildPreviewContent() {
    return Consumer<CVBuilderProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: CvPreviewCard(cvData: provider.currentCV),
        );
      },
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
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF6B7280),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: isRequired
              ? (value) {
                  // Only Name is strictly required for logical data model, 
                  // but UI can enforce more if needed. 
                  // Per user req: "minimal nama aja bisa save".
                  // So only Name field technically determines if valid to save,
                  // but form validation might want other fields.
                  // For now, let's just make Name required, others optional warning.
                  if (label.contains('Nama') && (value == null || value.isEmpty)) {
                    return l10n.requiredField;
                  }
                  return null;
                }
              : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
            helperText: helperText,
            helperStyle: const TextStyle(color: Color(0xFF0EA5E9)),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: const Color(0xFF6B7280))
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF0EA5E9)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
