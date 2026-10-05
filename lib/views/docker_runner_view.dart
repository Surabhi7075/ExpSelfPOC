import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/experience.dart';
import '../providers/experience_provider.dart';
import '../theme/app_theme.dart';

class DockerRunnerView extends StatefulWidget {
  const DockerRunnerView({Key? key}) : super(key: key);

  @override
  State<DockerRunnerView> createState() => _DockerRunnerViewState();
}

class _DockerRunnerViewState extends State<DockerRunnerView> {
  bool _isRunning = true;
  double _cpuUsage = 14.5;
  double _ramUsage = 380;
  List<String> _terminalLogs = [];
  Timer? _logTimer;

  @override
  void initState() {
    super.initState();
    _startTerminalLogStream();
  }

  void _startTerminalLogStream() {
    _terminalLogs = [
      '[DOCKER-ENGINE] Initializing local container runtime sandbox...',
      '[DOCKER-REGISTRY] Pulling layer sha256:8f43c2a91... [Cached locally]',
      '[SECURITY-SCAN] Verifying RSA 4096-bit signature against Certified Practice Key... PASSED',
      '[CONTAINER] Provisioning isolated CGroups and Namespace on Local Execution Plane...',
      '[CONTAINER-START] Execution environment started on port 8080.',
      '[MIGRATION-ENGINE] Ingesting source schemas...',
      '[TRANSFORMATION] Converting PL/SQL stored procedures to ANSI SQL & Kotlin services...',
    ];

    _logTimer = Timer.periodic(const Duration(seconds: 2), (t) {
      if (!mounted || !_isRunning) return;
      setState(() {
        _cpuUsage = 12.0 + (t.tick % 5) * 3.5;
        _ramUsage = 380 + (t.tick % 7) * 12.0;
        _terminalLogs.add('[LOG-${DateTime.now().second}] Executed automated schema test batch #${t.tick} | Status: 200 OK (0ms latency)');
        if (_terminalLogs.length > 25) _terminalLogs.removeAt(0);
      });
    });
  }

  @override
  void dispose() {
    _logTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExperienceProvider>(context);
    final activeExp = provider.activeExperience ??
        provider.allExperiences.firstWhere((e) => e.type == ExperienceType.container,
            orElse: () => provider.allExperiences.first);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => provider.setActiveNavIndex(0),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.token, color: AppTheme.accentAmber, size: 24),
                        const SizedBox(width: 10),
                        Text(activeExp.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                    Text('Image Tag: ${activeExp.contentUrl}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontFamily: 'monospace')),
                  ],
                ),
                const Spacer(),

                // Start / Stop Controls
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRunning ? AppTheme.accentRose : AppTheme.accentEmerald,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    setState(() {
                      _isRunning = !_isRunning;
                    });
                  },
                  icon: Icon(_isRunning ? Icons.stop : Icons.play_arrow, color: Colors.black),
                  label: Text(_isRunning ? 'Stop Container' : 'Start Container', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Performance Metrics Cards
            Row(
              children: [
                Expanded(child: _buildMetricCard('CPU Allocation', '${_cpuUsage.toStringAsFixed(1)}%', Icons.memory, AppTheme.primaryCyan)),
                const SizedBox(width: 12),
                Expanded(child: _buildMetricCard('RAM Usage', '${_ramUsage.toStringAsFixed(0)} MB', Icons.dns, AppTheme.accentIndigo)),
                const SizedBox(width: 12),
                Expanded(child: _buildMetricCard('Network Latency', '0.4 ms (Local Loopback)', Icons.speed, AppTheme.accentEmerald)),
              ],
            ),
            const SizedBox(height: 20),

            // Live Terminal Log Stream
            const Text('LIVE CONTAINER TERMINAL LOGS', style: TextStyle(color: AppTheme.primaryCyan, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: ListView.builder(
                  itemCount: _terminalLogs.length,
                  itemBuilder: (context, index) {
                    final log = _terminalLogs[index];
                    Color logColor = Colors.white70;
                    if (log.contains('SECURITY')) logColor = AppTheme.accentEmerald;
                    if (log.contains('LOG-')) logColor = AppTheme.primaryCyan;
                    if (log.contains('CONTAINER-START')) logColor = AppTheme.accentAmber;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        log,
                        style: TextStyle(color: logColor, fontFamily: 'monospace', fontSize: 12),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String val, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11)),
              Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
