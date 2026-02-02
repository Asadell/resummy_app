import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:resummy_app/app/routes/app_router.gr.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home,
                    label: 'Home',
                    isActive: tabsRouter.activeIndex == 0,
                    onTap: () => tabsRouter.setActiveIndex(0),
                  ),
                  _NavBarItem(
                    icon: Icons.description_outlined,
                    activeIcon: Icons.description,
                    label: 'CV Tools',
                    isActive: tabsRouter.activeIndex == 1,
                    onTap: () => tabsRouter.setActiveIndex(1),
                  ),
                  _NavBarItem(
                    icon: Icons.mic_none,
                    activeIcon: Icons.mic,
                    label: 'Interview',
                    isActive: tabsRouter.activeIndex == 2,
                    onTap: () => tabsRouter.setActiveIndex(2),
                  ),
                  _NavBarItem(
                    icon: Icons.history,
                    activeIcon: Icons.history,
                    label: 'History',
                    isActive: tabsRouter.activeIndex == 3,
                    onTap: () => tabsRouter.setActiveIndex(3),
                  ),
                  _NavBarItem(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    label: 'Profile',
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
              color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
