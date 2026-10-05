import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/experience.dart';
import '../providers/experience_provider.dart';
import '../theme/app_theme.dart';

class AgenticView extends StatefulWidget {
  const AgenticView({Key? key}) : super(key: key);

  @override
  State<AgenticView> createState() => _AgenticViewState();
}

class _AgenticViewState extends State<AgenticView> {
  final TextEditingController _promptController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'agent': 'Orchestrator Agent',
      'role': 'system',
      'text': 'Agentic Workflow initialized. 3 autonomous agents ready to assist presenter with financial risk analysis.'
    },
    {
      'agent': 'Ingestion & Parser Agent',
      'role': 'agent',
      'text': 'Ingested target financial statements. Normalized balance sheets and quarterly filings.'
    },
    {
      'agent': 'Risk Simulation Agent',
      'role': 'agent',
      'text': 'Executed 5,000 Monte Carlo stress test iterations. Liquidity ratio meets Basel III compliance thresholds.'
    },
  ];

  void _sendMessage() {
    if (_promptController.text.trim().isEmpty) return;
    final text = _promptController.text.trim();
    _promptController.clear();

    setState(() {
      _messages.add({'agent': 'Presenter', 'role': 'user', 'text': text});
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'agent': 'AI Synthesizer Agent',
          'role': 'agent',
          'text': 'Analyzing prompt "$text"... Generated executive summary slide and recommended follow-up demonstration.'
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExperienceProvider>(context);
    final activeExp = provider.activeExperience ??
        provider.allExperiences.firstWhere((e) => e.type == ExperienceType.agentic,
            orElse: () => provider.allExperiences.first);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Top Bar
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => provider.setActiveNavIndex(0),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    const Icon(Icons.smart_toy, color: AppTheme.accentIndigo, size: 28),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activeExp.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text('Multi-Agent Autonomous Workflow Engine', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Agent Status Pipeline
            Row(
              children: [
                Expanded(child: _buildAgentStep('1. Intake Agent', 'Active', AppTheme.accentEmerald)),
                const SizedBox(width: 8),
                Expanded(child: _buildAgentStep('2. Vector Retriever', 'Active', AppTheme.primaryCyan)),
                const SizedBox(width: 8),
                Expanded(child: _buildAgentStep('3. Compliance Agent', 'Standby', AppTheme.accentAmber)),
              ],
            ),
            const SizedBox(height: 16),

            // Messages Stream
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.surfaceBorder),
                ),
                child: ListView.builder(
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isUser = msg['role'] == 'user';

                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.all(14),
                        constraints: const BoxConstraints(maxWidth: 600),
                        decoration: BoxDecoration(
                          color: isUser ? AppTheme.accentIndigo : AppTheme.surfaceLight,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isUser ? AppTheme.accentIndigo : AppTheme.surfaceBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg['agent']!,
                              style: TextStyle(
                                color: isUser ? Colors.white : AppTheme.primaryCyan,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              msg['text']!,
                              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Prompt Input
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.surfaceBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promptController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Ask agent to perform a specific stress test or analysis...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppTheme.primaryCyan),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgentStep(String name, String status, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 5, backgroundColor: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                Text(status, style: TextStyle(color: color, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
