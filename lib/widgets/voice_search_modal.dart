import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/experience_provider.dart';
import '../theme/app_theme.dart';

class VoiceSearchModal extends StatefulWidget {
  const VoiceSearchModal({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VoiceSearchModal(),
    );
  }

  @override
  State<VoiceSearchModal> createState() => _VoiceSearchModalState();
}

class _VoiceSearchModalState extends State<VoiceSearchModal> with TickerProviderStateMixin {
  late AnimationController _animController;
  int _speechStep = 0;
  String _transcribedText = '';
  String _detectedIntent = '';

  final List<String> _samplePrompts = [
    'Show me COBOL modernization and legacy code transformation',
    'Find financial risk assessment AI agents',
    'Demonstrate cloud native Kubernetes visualizer',
    'Show database migration Docker sandbox',
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _simulateVoiceInput(String prompt) {
    setState(() {
      _speechStep = 1; // Listening & Transcribing
      _transcribedText = prompt;
    });

    Timer(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        _speechStep = 2; // Interpreting Intent
        _detectedIntent = _deriveIntent(prompt);
      });

      Timer(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        final provider = Provider.of<ExperienceProvider>(context, listen: false);
        provider.setSearchQuery(_extractKeyword(prompt));
        provider.setActiveNavIndex(0); // Go to discovery
        Navigator.of(context).pop();
      });
    });
  }

  String _deriveIntent(String prompt) {
    if (prompt.contains('COBOL')) return 'INTENT: Filter Legacy Modernization Practice (High Relevance)';
    if (prompt.contains('financial') || prompt.contains('risk')) return 'INTENT: Retrieve Agentic AI Workflows for Banking';
    if (prompt.contains('Kubernetes') || prompt.contains('cloud')) return 'INTENT: Launch Interactive Cloud Architecture App';
    if (prompt.contains('database') || prompt.contains('Docker')) return 'INTENT: Run Docker Container Migration Sandbox';
    return 'INTENT: Perform Semantic Vector Search across All Experiences';
  }

  String _extractKeyword(String prompt) {
    if (prompt.contains('COBOL')) return 'COBOL';
    if (prompt.contains('financial')) return 'financial';
    if (prompt.contains('Kubernetes') || prompt.contains('cloud')) return 'cloud';
    if (prompt.contains('database') || prompt.contains('Docker')) return 'Docker';
    return prompt;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        border: Border(top: BorderSide(color: AppTheme.primaryCyan, width: 2)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Icon(Icons.graphic_eq, color: AppTheme.primaryCyan, size: 28),
                    SizedBox(width: 10),
                    Text(
                      'AI Voice Search (Intent Engine)',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Animated Listening Equalizer
            AnimatedBuilder(
              animation: _animController,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(7, (index) {
                    final height = 20.0 + ((index % 3 + 1) * 15 * _animController.value);
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: height,
                      decoration: BoxDecoration(
                        color: Color.lerp(AppTheme.primaryCyan, AppTheme.accentIndigo, index / 7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                );
              },
            ),
            const SizedBox(height: 20),

            if (_speechStep == 0) ...[
              const Text(
                'Tap a voice prompt below or speak into your microphone:',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _samplePrompts.map((p) {
                  return ActionChip(
                    backgroundColor: AppTheme.surfaceLight,
                    avatar: const Icon(Icons.mic, size: 16, color: AppTheme.primaryCyan),
                    label: Text(p, style: const TextStyle(color: Colors.white, fontSize: 13)),
                    onPressed: () => _simulateVoiceInput(p),
                  );
                }).toList(),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primaryCyan.withOpacity(0.4)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.record_voice_over, color: AppTheme.primaryCyan, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '"$_transcribedText"',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    if (_speechStep >= 2) ...[
                      const Divider(color: Colors.white12, height: 20),
                      Row(
                        children: [
                          const Icon(Icons.psychology, color: AppTheme.accentEmerald, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _detectedIntent,
                              style: const TextStyle(color: AppTheme.accentEmerald, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
