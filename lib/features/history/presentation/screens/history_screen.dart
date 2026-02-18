import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/theme/app_sizes.dart';
import 'package:resummy_app/features/history/domain/entities/activity_item.dart';
import 'package:resummy_app/features/history/presentation/providers/history_provider.dart';
import 'package:resummy_app/features/history/presentation/widgets/suggestion_card.dart';
import 'package:resummy_app/features/history/presentation/widgets/weekly_insight_card.dart';
import 'package:resummy_app/features/cv_tools/presentation/widgets/cv_history_card.dart';
import 'package:resummy_app/features/interview/presentation/widgets/interview_history_card.dart';

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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          l10n.activityHistory,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => context.router.maybePop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.filter),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<HistoryProvider>(
        builder: (context, provider, child) {
          final l10n = AppLocalizations.of(context)!;
          if (provider.isLoading && provider.activities.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadActivities(),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.lg,
                      vertical: AppSizes.md,
                    ),
                    color: Colors.grey[100],
                    child: Center(
                      child: Text(
                        l10n.historySubtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.md),
                    child: const WeeklyInsightCard(),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickyFilterDelegate(
                    child: _FilterTabs(
                      currentFilter: provider.filter,
                      onFilterChanged: provider.setFilter,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.md),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
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

                        if (index == 3) {
                          return Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: AppSizes.md),
                                child: SuggestionCard(),
                              ),
                              _buildActivityItem(provider.activities[index], index),
                            ],
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSizes.md),
                          child: _buildActivityItem(provider.activities[index], index),
                        );
                      },
                      childCount: provider.activities.length + 1,
                    ),
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
    if (item is CvActivityItem) {
      return Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.blue.shade500, width: 4)),
        ),
        child: CvHistoryCard(cv: item.cvData, index: index),
      );
    } else if (item is InterviewActivityItem) {
      return Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: Colors.green.shade500, width: 4)),
        ),
        child: InterviewHistoryCard(interview: item.interview),
      );
    }
    return const SizedBox();
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
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.lg,
        vertical: AppSizes.md,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200] ?? Colors.grey),
        ),
      ),
      child: Row(
        children: [
          _buildTab(context, l10n.filterAll, HistoryFilter.all),
          const SizedBox(width: AppSizes.lg),
          _buildTab(context, l10n.filterCv, HistoryFilter.cv),
          const SizedBox(width: AppSizes.lg),
          _buildTab(context, l10n.filterInterview, HistoryFilter.interview),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, String label, HistoryFilter filter) {
    final isSelected = currentFilter == filter;
    return GestureDetector(
      onTap: () => onFilterChanged(filter),
      child: Container(
        padding: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                )
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[600],
          ),
        ),
      ),
    );
  }
}

class _StickyFilterDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyFilterDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
