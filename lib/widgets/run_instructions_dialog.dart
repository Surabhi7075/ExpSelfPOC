import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RunInstructionsDialog extends StatelessWidget {
  const RunInstructionsDialog({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const RunInstructionsDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.primaryCyan, width: 1.5),
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700, maxHeight: 650),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryCyan.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.rocket_launch, color: AppTheme.primaryCyan, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How to Run Experience Centre OS',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Cross-Platform Execution Guide for Android, iOS & Web',
                          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                ),
              ],
            ),
            const Divider(color: AppTheme.surfaceBorder, height: 28),
            Expanded(
              child: ListView(
                children: [
                  _buildPlatformCard(
                    context,
                    title: '1. Web (Google Chrome / Safari / Edge)',
                    icon: Icons.web,
                    color: Colors.blueAccent,
                    command: 'flutter run -d chrome',
                    buildCmd: 'flutter build web --release',
                    description: 'Runs the Experience Centre OS directly in Chrome with hot reload, web player support, and full responsive layout testing.',
                  ),
                  const SizedBox(height: 16),
                  _buildPlatformCard(
                    context,
                    title: '2. Android (Emulator or Physical Touch Display)',
                    icon: Icons.android,
                    color: Colors.greenAccent,
                    command: 'flutter run -d android',
                    buildCmd: 'flutter build apk --release',
                    description: 'Deploys to connected Android devices, tablets, smart touch kiosks or Android TV units. Ensure developer mode and USB debugging are enabled.',
                  ),
                  const SizedBox(height: 16),
                  _buildPlatformCard(
                    context,
                    title: '3. iOS (Simulator or iPad / iPhone)',
                    icon: Icons.apple,
                    color: Colors.purpleAccent,
                    command: 'flutter run -d ios',
                    buildCmd: 'flutter build ipa --release',
                    description: 'Deploys to iOS Simulators or connected iPad/iPhone hardware using Xcode developer toolchain.',
                  ),
                  const SizedBox(height: 16),
                  _buildPlatformCard(
                    context,
                    title: '4. macOS / Desktop OS Execution',
                    icon: Icons.desktop_mac,
                    color: Colors.cyanAccent,
                    command: 'flutter run -d macos',
                    buildCmd: 'flutter build macos',
                    description: 'Executes as a native desktop application on macOS with native windowing and hardware acceleration.',
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryCyan.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.primaryCyan.withOpacity(0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.lightbulb, color: AppTheme.primaryCyan, size: 22),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Design Responsiveness Note:\nThis OS automatically adapts its layout based on screen width! Mobile devices switch to compact bottom navigation, Tablets switch to responsive dual pane, and Touch Desktops/Kiosks expand into full multi-stage OS view.',
                            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryCyan,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Got it, let\'s explore!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String command,
    required String buildCmd,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SelectableText(
                  '\$ $command',
                  style: const TextStyle(color: AppTheme.primaryCyan, fontFamily: 'monospace', fontSize: 13),
                ),
                const Icon(Icons.copy, color: Colors.white38, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
