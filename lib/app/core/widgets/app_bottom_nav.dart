import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_color.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  static const _items = [
    _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home', route: Routes.home),
    _NavItem(icon: Icons.description_outlined, activeIcon: Icons.description_rounded, label: 'Invoices', route: Routes.invoices),
    _NavItem(icon: Icons.group_outlined, activeIcon: Icons.group_rounded, label: 'Customers', route: Routes.CUSTOMER_LIST),
    _NavItem(icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2_rounded, label: 'Products', route: Routes.PRODUCT_LIST),
    _NavItem(icon: Icons.settings_outlined, activeIcon: Icons.settings_rounded, label: 'Settings', route: ''),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColor.darkSurfaceContainer : AppColor.surfaceContainerLowest;
    final activeColor = isDark ? AppColor.primaryFixedDim : AppColor.primary;
    final inactiveColor = isDark ? AppColor.secondaryFixedDim : AppColor.secondary;

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: bg,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -4))],
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
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: isActive
                          ? BoxDecoration(
                        color: activeColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                      )
                          : null,
                      child: Icon(
                        isActive ? item.activeIcon : item.icon,
                        color: isActive ? activeColor : inactiveColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                        color: isActive ? activeColor : inactiveColor,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
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
  const _NavItem({required this.icon, required this.activeIcon, required this.label, required this.route});
}