import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'package:resummy_app/features/history/domain/entities/activity_item.dart';
import 'package:resummy_app/features/history/presentation/providers/history_provider.dart';
import 'package:resummy_app/features/history/presentation/widgets/suggestion_card.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_history_card.dart';
import 'package:resummy_app/features/interview/presentation/widgets/interview_history_card.dart';
import 'package:resummy_app/shared/widgets/app_section.dart';

@RoutePage()
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryProvider>().loadActivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.activityHistory),
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.activities.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadActivities(),
            child: Column(
              children: [
                _FilterTabs(
                  currentFilter: provider.filter,
                  onFilterChanged: provider.setFilter,
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.only(top: AppSizes.sm),
                    itemCount: provider.activities.length + 1,
                    separatorBuilder: (context, index) => const SizedBox(height: AppSizes.sm),
                    itemBuilder: (context, index) {
                      if (index == provider.activities.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
                          child: Center(
                            child: Text(
                              l10n.moreHistoryWillAppear,
                              style: TextStyle(color: Colors.grey[500], fontSize: 12),
                            ),
                          ),
                        );
                      }

                      final item = provider.activities[index];
                      
                      // Show suggestion card at index 3
                      if (index == 3) {
                        return Column(
                          spacing: AppSizes.sm,
                          children: [
                            const AppSection(
                              padding: EdgeInsets.zero,
                              child: SuggestionCard(),
                            ),
                            _buildActivityItem(item, index),
                          ],
                        );
                      }

                      return _buildActivityItem(item, index);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActivityItem(ActivityItem item, int index) {
    return AppSection(
      padding: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: item is CvActivityItem
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.tertiary,
              width: 4,
            ),
          ),
        ),
        child: item is CvActivityItem
            ? CvHistoryCard(cv: item.cvData, index: index)
            : item is InterviewActivityItem
                ? InterviewHistoryCard(interview: item.interview)
                : const SizedBox(),
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  final HistoryFilter currentFilter;
  final ValueChanged<HistoryFilter> onFilterChanged;

  const _FilterTabs({
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppSection(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.sm,
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(AppSizes.md),
        ),
        child: Row(
          children: [
            Expanded(child: _buildTab(context, l10n.filterAll, HistoryFilter.all)),
            Expanded(child: _buildTab(context, l10n.filterCv, HistoryFilter.cv)),
            Expanded(child: _buildTab(context, l10n.filterInterview, HistoryFilter.interview)),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String label, HistoryFilter filter) {
    final isSelected = currentFilter == filter;
    return GestureDetector(
      onTap: () => onFilterChanged(filter),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
          borderRadius: BorderRadius.circular(AppSizes.sm),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
