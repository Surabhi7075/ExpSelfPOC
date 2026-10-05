import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/experience_provider.dart';
import '../theme/app_theme.dart';

class LocalRegistryView extends StatelessWidget {
  const LocalRegistryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExperienceProvider>(context);
    final experiences = provider.allExperiences;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Local Experience Registry & Offline Execution Plane',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Manage local storage caching, pre-warming strategies, and zero-latency execution',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),

            // Metrics Cards
            Row(
              children: [
                Expanded(child: _buildStorageCard('Local Cache Storage', '14.8 GB / 64 GB', '23% Used', Icons.sd_card, AppTheme.primaryCyan)),
                const SizedBox(width: 12),
                Expanded(child: _buildStorageCard('Pre-Warmed Assets', '${experiences.where((e) => e.isPreWarmed).length} Ready', 'Zero Latency', Icons.bolt, AppTheme.accentEmerald)),
                const SizedBox(width: 12),
                Expanded(child: _buildStorageCard('Registry Security Score', '99.8%', 'RSA Signed', Icons.verified, AppTheme.accentIndigo)),
              ],
            ),
            const SizedBox(height: 24),

            // Offline Architecture Table
            const Text('OFFLINE ARCHITECTURE BEHAVIOR', style: TextStyle(color: AppTheme.primaryCyan, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: Column(
                children: [
                  _buildArchRow('Video / Media', 'Works directly from local high-speed SSD cache', AppTheme.accentEmerald),
                  const Divider(color: AppTheme.surfaceBorder),
                  _buildArchRow('Interactive Web', 'Executes inside embedded local WebAssembly sandbox', AppTheme.accentEmerald),
                  const Divider(color: AppTheme.surfaceBorder),
                  _buildArchRow('Local Docker Container', 'Runs from cached local Docker Registry images', AppTheme.accentEmerald),
                  const Divider(color: AppTheme.surfaceBorder),
                  _buildArchRow('Cloud AI Services', 'Falls back to Local Quantized Llama3 Model when offline', AppTheme.accentAmber),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // Pre-Warming & Cache Registry Table
            const Text('EXPERIENCE PRE-WARMING & CACHE MANAGER', style: TextStyle(color: AppTheme.primaryCyan, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 10),

            Card(
              color: AppTheme.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: AppTheme.surfaceBorder)),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: experiences.length,
                separatorBuilder: (context, index) => const Divider(color: AppTheme.surfaceBorder, height: 1),
                itemBuilder: (context, index) {
                  final exp = experiences[index];

                  return ListTile(
                    title: Text(exp.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: Text('${exp.practice} • ${exp.typeLabel} • ${exp.version}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Pre-warm switch
                        Row(
                          children: [
                            const Text('Pre-Warm', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                            Switch(
                              value: exp.isPreWarmed,
                              activeColor: AppTheme.accentEmerald,
                              onChanged: (_) => provider.togglePreWarm(exp.id),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        // Local Cache switch
                        Row(
                          children: [
                            const Text('Local Cache', style: TextStyle(color: AppTheme.textMuted, fontSize: 12)),
                            Switch(
                              value: exp.isCachedLocally,
                              activeColor: AppTheme.primaryCyan,
                              onChanged: (_) => provider.toggleLocalCache(exp.id),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageCard(String title, String mainVal, String subVal, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(mainVal, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subVal, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildArchRow(String type, String desc, Color statusColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(type, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          Expanded(
            child: Text(desc, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
            child: Text('OFFLINE CAPABLE', style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
