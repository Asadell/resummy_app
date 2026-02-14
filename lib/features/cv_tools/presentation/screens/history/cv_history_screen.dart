import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';
import 'package:resummy_app/core/providers/auth_provider.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_history_entity.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_history_provider.dart';
import 'package:resummy_app/features/cv_tools/presentation/screens/history/cv_analyzer_history_detail_screen.dart';

@RoutePage()
class CvHistoryScreen extends StatefulWidget {
  const CvHistoryScreen({super.key});

  @override
  State<CvHistoryScreen> createState() => _CvHistoryScreenState();
}

class _CvHistoryScreenState extends State<CvHistoryScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.uid;
      if (userId != null) {
        context.read<CvHistoryProvider>().loadCvAnalysisHistory(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final historyProvider = context.watch<CvHistoryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cvHistory),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.filter),
            onPressed: () => _showFilterBottomSheet(context),
          ),
          IconButton(
            icon: const Icon(Iconsax.sort),
            onPressed: () => _showSortBottomSheet(context),
          ),
        ],
      ),
      body: SafeArea(
        child: historyProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : historyProvider.errorMessage.isNotEmpty
                ? _buildErrorView(historyProvider.errorMessage, l10n)
                : historyProvider.historyList.isEmpty
                    ? _buildEmptyView(l10n)
                    : _buildHistoryList(historyProvider.historyList, l10n),
      ),
    );
  }

  Widget _buildErrorView(String errorMessage, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.danger,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading history',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                final userId = context.read<AuthProvider>().user?.uid;
                if (userId != null) {
                  context.read<CvHistoryProvider>().loadCvAnalysisHistory(userId);
                }
              },
              icon: const Icon(Iconsax.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.document,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No Analysis History',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Analyze a CV to see your history here',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<CvAnalysisHistory> historyList, AppLocalizations l10n) {
    return RefreshIndicator(
      onRefresh: () async {
        final userId = context.read<AuthProvider>().user?.uid;
        if (userId != null) {
          await context.read<CvHistoryProvider>().loadCvAnalysisHistory(userId);
        }
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          final history = historyList[index];
          return _buildHistoryCard(history, l10n);
        },
      ),
    );
  }

  Widget _buildHistoryCard(CvAnalysisHistory history, AppLocalizations l10n) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon instead of score
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Iconsax.document_text,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        history.cvFileName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Iconsax.clock,
                            size: 14,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(history.analyzedAt),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Badge and chips row
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Tool badge
                Chip(
                  avatar: Icon(
                    Iconsax.document_text,
                    size: 16,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  label: const Text(
                    'CV Analyzer',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                  side: BorderSide.none,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                ),
                // Grade chip
                Chip(
                  label: Text(
                    history.grade,
                    style: TextStyle(
                      color: _getScoreColor(history.score),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  backgroundColor: _getScoreColor(history.score).withAlpha(30),
                  side: BorderSide(color: _getScoreColor(history.score)),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                ),
                if (history.positionTarget != null)
                  Chip(
                    avatar: Icon(
                      Iconsax.briefcase,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    label: Text(
                      history.positionTarget!,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _navigateToDetail(context, history),
                    icon: const Icon(Iconsax.eye, size: 18),
                    label: const Text('See Detail'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => _showDeleteConfirmation(context, history, l10n),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  child: const Icon(Iconsax.trash, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 85) return Colors.green;
    if (score >= 70) return Colors.blue;
    if (score >= 50) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  void _navigateToDetail(BuildContext context, CvAnalysisHistory history) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CvAnalyzerHistoryDetailScreen(history: history),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, CvAnalysisHistory history, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete History?'),
        content: Text(
          'Are you sure you want to delete "${history.cvFileName}" from history? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await context
                  .read<CvHistoryProvider>()
                  .deleteCvAnalysisHistory(history.id);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'History deleted successfully'
                          : context.read<CvHistoryProvider>().errorMessage,
                    ),
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    final currentFilter = context.read<CvHistoryProvider>().currentFilter;

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter by Feature',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildFilterOption(HistoryFilter.all, 'All', Iconsax.menu, currentFilter),
            _buildFilterOption(HistoryFilter.cvAnalyzer, 'CV Analyzer', Iconsax.document_text, currentFilter),
            _buildFilterOption(HistoryFilter.cvBuilder, 'CV Builder', Iconsax.edit, currentFilter),
            _buildFilterOption(HistoryFilter.cvTranslator, 'CV Translator', Iconsax.translate, currentFilter),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(
    HistoryFilter filter,
    String label,
    IconData icon,
    HistoryFilter currentFilter,
  ) {
    final isSelected = filter == currentFilter;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Iconsax.tick_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: () {
        context.read<CvHistoryProvider>().setFilter(filter);
        Navigator.pop(context);
      },
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    final currentSort = context.read<CvHistoryProvider>().currentSort;

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort by Time',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildSortOption(HistorySortOrder.newestFirst, 'Newest First', Iconsax.arrow_down, currentSort),
            _buildSortOption(HistorySortOrder.oldestFirst, 'Oldest First', Iconsax.arrow_up, currentSort),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(
    HistorySortOrder sort,
    String label,
    IconData icon,
    HistorySortOrder currentSort,
  ) {
    final isSelected = sort == currentSort;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
        ),
      ),
      trailing: isSelected
          ? Icon(
              Iconsax.tick_circle,
              color: Theme.of(context).colorScheme.primary,
            )
          : null,
      onTap: () {
        context.read<CvHistoryProvider>().setSortOrder(sort);
        Navigator.pop(context);
      },
    );
  }
}
