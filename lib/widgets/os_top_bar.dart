import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/experience.dart';
import '../providers/experience_provider.dart';
import '../theme/app_theme.dart';
import 'run_instructions_dialog.dart';

class OsTopBar extends StatefulWidget implements PreferredSizeWidget {
  const OsTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  State<OsTopBar> createState() => _OsTopBarState();
}

class _OsTopBarState extends State<OsTopBar> {
  late String _timeString;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (mounted) {
      setState(() {
        _timeString = formattedDateTime;
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExperienceProvider>(context);
    final isMobile = AppTheme.isMobile(context);

    return Container(
      height: widget.preferredSize.height,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        border: Border(bottom: BorderSide(color: AppTheme.surfaceLight, width: 1)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // OS Logo & Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primaryCyan, AppTheme.accentIndigo],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.blur_on, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Experience Centre OS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryCyan.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppTheme.primaryCyan.withValues(alpha: 0.4)),
                          ),
                          child: const Text(
                            'v1.1',
                            style: TextStyle(color: AppTheme.primaryCyan, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Local Execution Plane • Touch First',
                      style: TextStyle(color: AppTheme.textMuted, fontSize: 10),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(width: 16),

            // Local / Offline Status Indicator
            GestureDetector(
              onTap: () => provider.toggleOfflineMode(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: provider.isOfflineMode
                      ? AppTheme.accentAmber.withValues(alpha: 0.15)
                      : AppTheme.accentEmerald.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: provider.isOfflineMode ? AppTheme.accentAmber : AppTheme.accentEmerald,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      provider.isOfflineMode ? Icons.wifi_off : Icons.offline_pin,
                      color: provider.isOfflineMode ? AppTheme.accentAmber : AppTheme.accentEmerald,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      provider.isOfflineMode ? 'Offline Local Cache' : 'Local Cache Ready',
                      style: TextStyle(
                        color: provider.isOfflineMode ? AppTheme.accentAmber : AppTheme.accentEmerald,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),

            // User Role Switcher Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceLight,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<UserRole>(
                  value: provider.currentRole,
                  dropdownColor: AppTheme.surface,
                  icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primaryCyan),
                  items: UserRole.values.map((role) {
                    String label;
                    switch (role) {
                      case UserRole.presenter:
                        label = 'Presenter View';
                        break;
                      case UserRole.practiceContributor:
                        label = 'Contributor View';
                        break;
                      case UserRole.practiceAdmin:
                        label = 'Practice Admin';
                        break;
                      case UserRole.centreAdmin:
                        label = 'Centre Admin';
                        break;
                      case UserRole.platformAdmin:
                        label = 'Platform Admin';
                        break;
                    }
                    return DropdownMenuItem<UserRole>(
                      value: role,
                      child: Row(
                        children: [
                          const Icon(Icons.person_pin, color: AppTheme.primaryCyan, size: 16),
                          const SizedBox(width: 6),
                          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (role) {
                    if (role != null) provider.setRole(role);
                  },
                ),
              ),
            ),
            const SizedBox(width: 10),

            // How to Run Action Button
            Tooltip(
              message: 'How to Run Instructions',
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentIndigo,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => RunInstructionsDialog.show(context),
                icon: const Icon(Icons.help_outline, color: Colors.white, size: 16),
                label: const Text('How to Run', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 10),

            // OS Time Clock
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _timeString,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
