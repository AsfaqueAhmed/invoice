import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/theme/app_colors.dart';
import '../constants/app_decorations.dart';
import '../../routes/app_pages.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  static const _items = [
    _NavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Home',
        route: Routes.dashboard),
    _NavItem(
        icon: Icons.description_outlined,
        activeIcon: Icons.description_rounded,
        label: 'Invoices',
        route: Routes.invoices),
    _NavItem(
        icon: Icons.group_outlined,
        activeIcon: Icons.group_rounded,
        label: 'Customers',
        route: Routes.CUSTOMER_LIST),
    _NavItem(
        icon: Icons.inventory_2_outlined,
        activeIcon: Icons.inventory_2_rounded,
        label: 'Products',
        route: Routes.PRODUCT_LIST),
    _NavItem(
        icon: Icons.settings_outlined,
        activeIcon: Icons.settings_rounded,
        label: 'Settings',
        route: Routes.SETTINGS),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: colors.cardBg,
        boxShadow: AppDecorations.navShadow,
      ),
      child: Row(
        children: List.generate(_items.length, (i) {
          final item = _items[i];
          final isActive = i == currentIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isActive) Get.offAllNamed(item.route);
              },
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: isActive
                        ? BoxDecoration(
                            color: colors.primary.withOpacity(0.12),
                            borderRadius: AppDecorations.borderRadiusFull,
                          )
                        : null,
                    child: Icon(
                      isActive ? item.activeIcon : item.icon,
                      color: isActive
                          ? colors.primary
                          : colors.onSurfaceVariant,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isActive
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isActive
                          ? colors.primary
                          : colors.onSurfaceVariant,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
