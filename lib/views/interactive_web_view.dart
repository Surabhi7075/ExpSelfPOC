import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/experience.dart';
import '../providers/experience_provider.dart';
import '../theme/app_theme.dart';

class InteractiveWebView extends StatefulWidget {
  const InteractiveWebView({Key? key}) : super(key: key);

  @override
  State<InteractiveWebView> createState() => _InteractiveWebViewState();
}

class _InteractiveWebViewState extends State<InteractiveWebView> {
  String _simulatedDevice = 'Desktop (1920x1080)';
  bool _isLoading = false;
  int _activeTab = 0;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExperienceProvider>(context);
    final activeExp = provider.activeExperience ??
        provider.allExperiences.firstWhere((e) => e.type == ExperienceType.interactiveWeb,
            orElse: () => provider.allExperiences.first);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // Simulated Browser Address & Navigation Controls Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.surface,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  onPressed: () => provider.setActiveNavIndex(0),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: AppTheme.primaryCyan, size: 20),
                  onPressed: () {
                    setState(() => _isLoading = true);
                    Future.delayed(const Duration(milliseconds: 600), () {
                      if (mounted) setState(() => _isLoading = false);
                    });
                  },
                ),
                const SizedBox(width: 8),

                // Address Bar
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lock, color: AppTheme.accentEmerald, size: 14),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            activeExp.contentUrl,
                            style: const TextStyle(color: Colors.white70, fontSize: 13, fontFamily: 'monospace'),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.accentEmerald.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('ISOLATED SANDBOX', style: TextStyle(color: AppTheme.accentEmerald, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Device Simulator Selector
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _simulatedDevice,
                    dropdownColor: AppTheme.surface,
                    style: const TextStyle(color: AppTheme.primaryCyan, fontSize: 12, fontWeight: FontWeight.bold),
                    items: ['Desktop (1920x1080)', 'Touch Kiosk (1080x1920)', 'Tablet (1024x768)', 'Mobile (390x844)']
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _simulatedDevice = v);
                    },
                  ),
                ),
              ],
            ),
          ),

          // Main Web Application Sandbox Container
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppTheme.primaryCyan),
                        SizedBox(height: 16),
                        Text('Initializing Web Experience Runtime...', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: Column(
                      children: [
                        // Interactive Web App Top Bar Navigation
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: const BoxDecoration(
                            color: AppTheme.surfaceLight,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.hub, color: AppTheme.primaryCyan, size: 24),
                              const SizedBox(width: 10),
                              Text(activeExp.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                              const Spacer(),

                              // Interactive View Tabs
                              Row(
                                children: ['Overview Dashboard', 'Architecture Graph', 'Live Telemetry'].asMap().entries.map((entry) {
                                  final idx = entry.key;
                                  final label = entry.value;
                                  final isSel = _activeTab == idx;
                                  return GestureDetector(
                                    onTap: () => setState(() => _activeTab = idx),
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: isSel ? AppTheme.primaryCyan : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          color: isSel ? Colors.black : Colors.white70,
                                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),

                        // Tab Content Stage
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: _buildTabContent(activeExp),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(Experience exp) {
    if (_activeTab == 0) {
      return GridView.count(
        crossAxisCount: AppTheme.isMobile(context) ? 1 : 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
        children: [
          _buildStatCard('Cloud API Throughput', '142,500 req/sec', '+18.4%', AppTheme.accentEmerald, Icons.speed),
          _buildStatCard('Auto-Scaled Pods', '42 Active Nodes', 'Health 100%', AppTheme.primaryCyan, Icons.cloud_done),
          _buildStatCard('System Latency (P99)', '12.4 ms', '-4.2ms', AppTheme.accentIndigo, Icons.timer),
          _buildStatCard('Database Transactions', '99.999% Uptime', 'Zero Errors', AppTheme.accentAmber, Icons.storage),
          _buildStatCard('Security Ingress Policy', 'mTLS Enforced', 'Protected', AppTheme.accentRose, Icons.security),
          _buildStatCard('Cost Optimization', '\$4,200 / month saved', 'Local First', AppTheme.accentEmerald, Icons.monetization_on),
        ],
      );
    } else if (_activeTab == 1) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.surfaceBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Interactive System Microservice Topology', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            const Text('Touch or click any node to simulate traffic spikes and failover orchestration.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
            const Spacer(),
            Center(
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _buildNode('API Gateway', Icons.door_sliding, AppTheme.primaryCyan),
                  _buildNode('Auth Service', Icons.lock, AppTheme.accentIndigo),
                  _buildNode('Core Engine', Icons.memory, AppTheme.accentEmerald),
                  _buildNode('PostgreSQL DB', Icons.storage, AppTheme.accentAmber),
                  _buildNode('Redis Cache', Icons.bolt, AppTheme.accentRose),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Live Execution Logs & Memory Footprint', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: ListView(
                children: const [
                  Text('[SYSTEM] Ingress Controller initialized at local socket 127.0.0.1:8080', style: TextStyle(color: AppTheme.accentEmerald, fontFamily: 'monospace', fontSize: 12)),
                  Text('[SECURITY] TLS 1.3 Handshake completed successfully with Experience Centre OS Host', style: TextStyle(color: Colors.white70, fontFamily: 'monospace', fontSize: 12)),
                  Text('[RUNTIME] Loading Web Assembly module (WASM) for local rendering execution', style: TextStyle(color: AppTheme.primaryCyan, fontFamily: 'monospace', fontSize: 12)),
                  Text('[CACHE] Pre-warmed asset bundle loaded from local SSD registry', style: TextStyle(color: AppTheme.accentAmber, fontFamily: 'monospace', fontSize: 12)),
                  Text('[METRICS] P99 Latency = 1.2ms | CPU Usage = 4.2% | Memory = 128 MB', style: TextStyle(color: Colors.white70, fontFamily: 'monospace', fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildStatCard(String title, String value, String badge, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
            child: Text(badge, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildNode(String title, IconData icon, Color color) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
