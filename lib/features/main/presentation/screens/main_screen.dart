import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:resummy_app/core/routes/app_router.gr.dart';
import 'package:resummy_app/core/l10n/app_localizations.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AutoTabsScaffold(
      routes: const [
        HomeRoute(),
        CvToolsHubRoute(),
        InterviewPrepRoute(),
        HistoryRoute(),
        ProfileRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavBarItem(
                    icon: Iconsax.home,
                    activeIcon: Iconsax.home_2,
                    label: l10n.home,
                    isActive: tabsRouter.activeIndex == 0,
                    onTap: () => tabsRouter.setActiveIndex(0),
                  ),
                  _NavBarItem(
                    icon: Iconsax.document_text,
                    activeIcon: Iconsax.document_text_1,
                    label: l10n.cvTools,
                    isActive: tabsRouter.activeIndex == 1,
                    onTap: () => tabsRouter.setActiveIndex(1),
                  ),
                  _NavBarItem(
                    icon: Iconsax.microphone,
                    activeIcon: Iconsax.microphone_2,
                    label: l10n.interview,
                    isActive: tabsRouter.activeIndex == 2,
                    onTap: () => tabsRouter.setActiveIndex(2),
                  ),
                  _NavBarItem(
                    icon: Iconsax.clock,
                    activeIcon: Iconsax.clock,
                    label: l10n.history,
                    isActive: tabsRouter.activeIndex == 3,
                    onTap: () => tabsRouter.setActiveIndex(3),
                  ),
                  _NavBarItem(
                    icon: Iconsax.profile_circle,
                    activeIcon: Iconsax.user,
                    label: l10n.profile,
                    isActive: tabsRouter.activeIndex == 4,
                    onTap: () => tabsRouter.setActiveIndex(4),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color:
                  isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
