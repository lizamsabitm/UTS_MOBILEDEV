// core/widgets/app_bottom_nav.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback? onCenterTap;

  const AppBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.onCenterTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF445566),
        border: Border(
          top: BorderSide(color: Color(0xFF2C3946), width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              // 0: Films (Home Deck)
              _buildNavItem(
                index: 0,
                icon: Icons.layers_outlined,
                activeIcon: Icons.layers,
              ),
              // 1: Search
              _buildNavItem(
                index: 1,
                icon: Icons.search,
                activeIcon: Icons.search,
              ),
              // 2: Center Green Plus Button
              Expanded(
                child: Center(
                  child: _buildCenterPlusButton(),
                ),
              ),
              // 3: Activity / Lightning bolt
              _buildNavItem(
                index: 2,
                icon: Icons.bolt_outlined,
                activeIcon: Icons.bolt,
              ),
              // 4: Profile
              _buildNavItem(
                index: 3,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterPlusButton() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onCenterTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF00E054),
            width: 2.2,
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.add,
            size: 24,
            color: Color(0xFF00E054),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
  }) {
    final isSelected = currentIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF3D4F5F) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              isSelected ? activeIcon : icon,
              size: 24,
              color: isSelected ? const Color(0xFF40BCE8) : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
