import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/experience.dart';
import '../providers/experience_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/experience_card.dart';
import '../widgets/voice_search_modal.dart';

class DiscoveryView extends StatelessWidget {
  const DiscoveryView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExperienceProvider>(context);
    final experiences = provider.experiences;
    final isMobile = AppTheme.isMobile(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          // Header & Search Hero
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Experience Discovery Platform',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: isMobile ? 20 : 24,
                                ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Touch-first AI-assisted catalog of certified client experiences',
                            style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryCyan.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppTheme.primaryCyan.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          '${experiences.length} Experiences Ready',
                          style: const TextStyle(color: AppTheme.primaryCyan, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Search Bar with Voice AI Trigger
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppTheme.surfaceBorder, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: AppTheme.primaryCyan, size: 22),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            onChanged: (val) => provider.setSearchQuery(val),
                            controller: TextEditingController.fromValue(
                              TextEditingValue(
                                text: provider.searchQuery,
                                selection: TextSelection.collapsed(offset: provider.searchQuery.length),
                              ),
                            ),
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                            decoration: const InputDecoration(
                              hintText: 'Search experiences by title, technology, business outcome...',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              filled: false,
                            ),
                          ),
                        ),
                        if (provider.searchQuery.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear, color: AppTheme.textMuted, size: 18),
                            onPressed: () => provider.setSearchQuery(''),
                          ),
                        Container(
                          height: 24,
                          width: 1,
                          color: AppTheme.surfaceBorder,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryCyan,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () => VoiceSearchModal.show(context),
                          icon: const Icon(Icons.mic, size: 16),
                          label: Text(
                            isMobile ? '' : 'Voice AI',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Filters Row (Practice, Industry, Type Chips)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Practice Dropdown Filter
                        _buildFilterDropdown(
                          context,
                          label: 'Practice:',
                          value: provider.selectedPractice,
                          items: provider.practicesList,
                          onChanged: (val) {
                            if (val != null) provider.setSelectedPractice(val);
                          },
                        ),
                        const SizedBox(width: 10),

                        // Industry Dropdown Filter
                        _buildFilterDropdown(
                          context,
                          label: 'Industry:',
                          value: provider.selectedIndustry,
                          items: provider.industriesList,
                          onChanged: (val) {
                            if (val != null) provider.setSelectedIndustry(val);
                          },
                        ),
                        const SizedBox(width: 12),

                        // Experience Type Filter Chips
                        _buildTypeChip(context, provider, null, 'All Types', Icons.dashboard_outlined),
                        const SizedBox(width: 6),
                        _buildTypeChip(context, provider, ExperienceType.media, 'Media/Video', Icons.play_circle_outline),
                        const SizedBox(width: 6),
                        _buildTypeChip(context, provider, ExperienceType.interactiveWeb, 'Interactive Web', Icons.language),
                        const SizedBox(width: 6),
                        _buildTypeChip(context, provider, ExperienceType.container, 'Docker', Icons.token),
                        const SizedBox(width: 6),
                        _buildTypeChip(context, provider, ExperienceType.agentic, 'Agentic AI', Icons.smart_toy_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Experience Cards Grid
          if (experiences.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 56, color: AppTheme.textMuted),
                    const SizedBox(height: 14),
                    const Text('No Experiences Found', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    const Text('Try adjusting your search keywords or active practice filters.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryCyan),
                      onPressed: () {
                        provider.setSearchQuery('');
                        provider.setSelectedPractice('All Practices');
                        provider.setSelectedIndustry('All Industries');
                        provider.setSelectedType(null);
                      },
                      child: const Text('Reset All Filters', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: AppTheme.gridCrossAxisCount(context),
                  childAspectRatio: 0.78,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ExperienceCard(experience: experiences[index]);
                  },
                  childCount: experiences.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    BuildContext context, {
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.surfaceBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(width: 6),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: AppTheme.surface,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeChip(
    BuildContext context,
    ExperienceProvider provider,
    ExperienceType? type,
    String label,
    IconData icon,
  ) {
    final isSelected = provider.selectedType == type;

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isSelected ? Colors.black : AppTheme.primaryCyan),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 11,
            ),
          ),
        ],
      ),
      backgroundColor: AppTheme.surface,
      selectedColor: AppTheme.primaryCyan,
      side: BorderSide(
        color: isSelected ? AppTheme.primaryCyan : AppTheme.surfaceBorder,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (_) {
        provider.setSelectedType(type);
      },
    );
  }
}
