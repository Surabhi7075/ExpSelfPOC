import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/experience_provider.dart';
import '../theme/app_theme.dart';

class OsBottomNav extends StatelessWidget {
  const OsBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExperienceProvider>(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(top: BorderSide(color: AppTheme.surfaceLight, width: 1)),
      ),
      child: BottomNavigationBar(
        currentIndex: provider.activeNavIndex > 4 ? 0 : provider.activeNavIndex,
        onTap: (index) => provider.setActiveNavIndex(index),
        backgroundColor: AppTheme.surface,
        selectedItemColor: AppTheme.primaryCyan,
        unselectedItemColor: AppTheme.textSecondary,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            activeIcon: Icon(Icons.play_circle_filled),
            label: 'Media',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            activeIcon: Icon(Icons.language),
            label: 'Web',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.token),
            activeIcon: Icon(Icons.token),
            label: 'Docker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            activeIcon: Icon(Icons.smart_toy),
            label: 'Agentic',
          ),
        ],
      ),
    );
  }
}
