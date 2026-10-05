import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/experience_provider.dart';
import '../theme/app_theme.dart';
import 'voice_search_modal.dart';

class OsSidebar extends StatelessWidget {
  const OsSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExperienceProvider>(context);

    final navItems = [
      {'icon': Icons.explore_outlined, 'activeIcon': Icons.explore, 'label': 'Discovery'},
      {'icon': Icons.play_circle_outline, 'activeIcon': Icons.play_circle_filled, 'label': 'Media Player'},
      {'icon': Icons.language, 'activeIcon': Icons.language, 'label': 'Web Sandbox'},
      {'icon': Icons.token, 'activeIcon': Icons.token, 'label': 'Docker Engine'},
      {'icon': Icons.smart_toy_outlined, 'activeIcon': Icons.smart_toy, 'label': 'Agentic AI'},
      {'icon': Icons.admin_panel_settings_outlined, 'activeIcon': Icons.admin_panel_settings, 'label': 'Lifecycle Hub'},
      {'icon': Icons.storage_outlined, 'activeIcon': Icons.storage, 'label': 'Local Registry'},
    ];

    return Container(
      width: 210,
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(right: BorderSide(color: AppTheme.surfaceLight, width: 1)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // AI Voice Search Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: InkWell(
              onTap: () => VoiceSearchModal.show(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryCyan.withValues(alpha: 0.2),
                      AppTheme.accentIndigo.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryCyan.withValues(alpha: 0.5)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.mic, color: AppTheme.primaryCyan, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Voice Search', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          Text('Tap to speak', style: TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'SYSTEM NAVIGATION',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
          ),
          const SizedBox(height: 4),

          Expanded(
            child: ListView.builder(
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                final isSelected = provider.activeNavIndex == index;

                return _OsSidebarItem(
                  icon: item['icon'] as IconData,
                  activeIcon: item['activeIcon'] as IconData,
                  label: item['label'] as String,
                  isSelected: isSelected,
                  onTap: () => provider.setActiveNavIndex(index),
                );
              },
            ),
          ),

          // Active Playing Mini Banner if any
          if (provider.activeExperience != null) ...[
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primaryCyan),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.graphic_eq, color: AppTheme.primaryCyan, size: 14),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'Active Experience',
                          style: TextStyle(color: AppTheme.primaryCyan, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.close, color: AppTheme.textMuted, size: 14),
                        onPressed: () => provider.closeActiveExperience(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    provider.activeExperience!.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OsSidebarItem extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _OsSidebarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_OsSidebarItem> createState() => _OsSidebarItemState();
}

class _OsSidebarItemState extends State<_OsSidebarItem> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected || _isFocused;

    return Focus(
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: widget.isSelected
                    ? AppTheme.primaryCyan.withValues(alpha: 0.15)
                    : (_isFocused ? AppTheme.surfaceLight : Colors.transparent),
                borderRadius: BorderRadius.circular(10),
                border: _isFocused
                    ? Border.all(color: AppTheme.primaryCyan, width: 2)
                    : (widget.isSelected
                        ? Border.all(color: AppTheme.primaryCyan.withValues(alpha: 0.6), width: 1)
                        : Border.all(color: Colors.transparent)),
              ),
              child: Row(
                children: [
                  Icon(
                    active ? widget.activeIcon : widget.icon,
                    color: active ? AppTheme.primaryCyan : AppTheme.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: active ? Colors.white : AppTheme.textSecondary,
                        fontWeight: active ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
