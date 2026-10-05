import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/experience.dart';
import '../providers/experience_provider.dart';
import '../theme/app_theme.dart';

class ManagementView extends StatefulWidget {
  const ManagementView({Key? key}) : super(key: key);

  @override
  State<ManagementView> createState() => _ManagementViewState();
}

class _ManagementViewState extends State<ManagementView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _contentUrlController = TextEditingController(text: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4');
  final _techController = TextEditingController(text: 'Flutter, Dart, Firebase, Docker');
  final _problemController = TextEditingController(text: 'Complex multi-cloud onboarding bottlenecks');
  final _outcomeController = TextEditingController(text: '80% faster deployment and unified operations');

  ExperienceType _selectedType = ExperienceType.media;
  String _selectedPractice = 'Legacy Modernization';
  String _selectedIndustry = 'Banking & Financial Services';

  void _submitNewExperience() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ExperienceProvider>(context, listen: false);
      final newExp = Experience(
        id: 'EXP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        practice: _selectedPractice,
        capability: 'Custom Solution',
        industry: _selectedIndustry,
        businessProblem: _problemController.text.trim(),
        businessOutcome: _outcomeController.text.trim(),
        technology: _techController.text.trim(),
        tags: ['Custom', _selectedPractice, 'Certified'],
        imageUrl: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=600&q=80',
        type: _selectedType,
        contentUrl: _contentUrlController.text.trim(),
        duration: '10:00',
        version: 'v1.0.0',
        owner: 'Practice Contributor',
        status: LifecycleStatus.draft,
      );

      provider.addExperience(newExp);

      _titleController.clear();
      _descController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Experience Created Successfully as DRAFT! Ready for Testing & Certification.'),
          backgroundColor: AppTheme.accentEmerald,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExperienceProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Experience Lifecycle & Governance Hub',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Role: ${provider.currentRole.name.toUpperCase()} • Create, Test, Certify & Publish Experiences',
                      style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentIndigo.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.accentIndigo),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified_user, color: AppTheme.accentIndigo, size: 16),
                      SizedBox(width: 6),
                      Text('Security Gate Enforcement Active', style: TextStyle(color: AppTheme.accentIndigo, fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Form: Create New Experience
            Card(
              color: AppTheme.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.surfaceBorder),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.add_circle, color: AppTheme.primaryCyan, size: 22),
                          SizedBox(width: 10),
                          Text('Package New Experience', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                      const Divider(color: AppTheme.surfaceBorder, height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _titleController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(labelText: 'Experience Title *'),
                              validator: (val) => val == null || val.isEmpty ? 'Title is required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<ExperienceType>(
                              value: _selectedType,
                              dropdownColor: AppTheme.surface,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(labelText: 'Experience Type'),
                              items: ExperienceType.values.map((t) {
                                String label;
                                switch (t) {
                                  case ExperienceType.media:
                                    label = 'Media (Video / PDF)';
                                    break;
                                  case ExperienceType.interactiveWeb:
                                    label = 'Interactive Web Application';
                                    break;
                                  case ExperienceType.container:
                                    label = 'Docker Container Sandbox';
                                    break;
                                  case ExperienceType.agentic:
                                    label = 'Agentic AI Workflow';
                                    break;
                                }
                                return DropdownMenuItem(value: t, child: Text(label));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedType = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _descController,
                        maxLines: 2,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Short Description *'),
                        validator: (val) => val == null || val.isEmpty ? 'Description required' : null,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedPractice,
                              dropdownColor: AppTheme.surface,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(labelText: 'Practice'),
                              items: provider.practicesList.where((p) => p != 'All Practices').map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedPractice = val);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _selectedIndustry,
                              dropdownColor: AppTheme.surface,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(labelText: 'Industry'),
                              items: provider.industriesList.where((i) => i != 'All Industries').map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedIndustry = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        controller: _contentUrlController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Asset Content URL / Video Link / Docker Tag *'),
                      ),
                      const SizedBox(height: 20),

                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryCyan,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _submitNewExperience,
                          icon: const Icon(Icons.cloud_upload, color: Colors.black),
                          label: const Text('Package Experience into Draft', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Lifecycle Kanban Pipeline
            const Text('LIFECYCLE PIPELINE MATRIX', style: TextStyle(color: AppTheme.primaryCyan, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 12),

            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPipelineColumn('1. DRAFT', LifecycleStatus.draft, provider, AppTheme.accentAmber),
                      const SizedBox(width: 16),
                      _buildPipelineColumn('2. TESTING', LifecycleStatus.testing, provider, AppTheme.primaryBlue),
                      const SizedBox(width: 16),
                      _buildPipelineColumn('3. CERTIFICATION', LifecycleStatus.certification, provider, AppTheme.accentIndigo),
                      const SizedBox(width: 16),
                      _buildPipelineColumn('4. PUBLISHED', LifecycleStatus.published, provider, AppTheme.accentEmerald),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPipelineColumn(String title, LifecycleStatus status, ExperienceProvider provider, Color color) {
    final list = provider.allExperiences.where((e) => e.status == status).toList();

    return Container(
      width: 280,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                child: Text('${list.length}', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const Divider(color: AppTheme.surfaceBorder, height: 20),

          if (list.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: Text('No experiences', style: TextStyle(color: AppTheme.textMuted, fontSize: 12))),
            )
          else
            ...list.map((exp) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                color: AppTheme.surfaceLight,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exp.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(exp.practice, style: const TextStyle(color: AppTheme.primaryCyan, fontSize: 11)),
                      const SizedBox(height: 8),

                      // Pipeline Transition Action
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('v${exp.version}', style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                          if (status == LifecycleStatus.draft)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                              onPressed: () => provider.updateLifecycleStatus(exp.id, LifecycleStatus.testing),
                              child: const Text('Run Test', style: TextStyle(color: Colors.white, fontSize: 10)),
                            )
                          else if (status == LifecycleStatus.testing)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentIndigo, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                              onPressed: () => provider.updateLifecycleStatus(exp.id, LifecycleStatus.certification),
                              child: const Text('Scan & Certify', style: TextStyle(color: Colors.white, fontSize: 10)),
                            )
                          else if (status == LifecycleStatus.certification)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentEmerald, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4)),
                              onPressed: () => provider.updateLifecycleStatus(exp.id, LifecycleStatus.published),
                              child: const Text('Publish', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                            )
                          else
                            const Icon(Icons.check_circle, color: AppTheme.accentEmerald, size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
