import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/experience.dart';
import '../providers/experience_provider.dart';
import '../theme/app_theme.dart';

class ExperienceCard extends StatefulWidget {
  final Experience experience;

  const ExperienceCard({
    super.key,
    required this.experience,
  });

  @override
  State<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard> {
  bool _isFocused = false;

  Color _getTypeColor(ExperienceType type) {
    switch (type) {
      case ExperienceType.media:
        return AppTheme.primaryCyan;
      case ExperienceType.interactiveWeb:
        return AppTheme.primaryBlue;
      case ExperienceType.container:
        return AppTheme.accentAmber;
      case ExperienceType.agentic:
        return AppTheme.accentIndigo;
    }
  }

  IconData _getTypeIcon(ExperienceType type) {
    switch (type) {
      case ExperienceType.media:
        return Icons.play_arrow_rounded;
      case ExperienceType.interactiveWeb:
        return Icons.open_in_new_rounded;
      case ExperienceType.container:
        return Icons.terminal_rounded;
      case ExperienceType.agentic:
        return Icons.auto_awesome_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExperienceProvider>(context, listen: false);
    final typeColor = _getTypeColor(widget.experience.type);

    return Focus(
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isFocused ? AppTheme.primaryCyan : Colors.transparent,
            width: _isFocused ? 3 : 1,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: AppTheme.primaryCyan.withValues(alpha: 0.6),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: () => provider.launchExperience(widget.experience),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner Image Header with Overlay Badges
                Stack(
                  children: [
                    Image.network(
                      widget.experience.imageUrl,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 130,
                          color: AppTheme.surfaceLight,
                          child: const Center(
                            child: Icon(Icons.image_not_supported, color: AppTheme.textMuted, size: 36),
                          ),
                        );
                      },
                    ),
                    // Gradient Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.2),
                              Colors.black.withValues(alpha: 0.85),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Experience Type Badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: typeColor.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_getTypeIcon(widget.experience.type), color: Colors.white, size: 12),
                            const SizedBox(width: 4),
                            Text(
                              widget.experience.typeLabel,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Local Pre-Warm Status Badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: widget.experience.isPreWarmed ? AppTheme.accentEmerald : AppTheme.textMuted,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bolt,
                              color: widget.experience.isPreWarmed ? AppTheme.accentEmerald : AppTheme.textMuted,
                              size: 10,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              widget.experience.isPreWarmed ? 'PRE-WARMED' : 'CACHED',
                              style: TextStyle(
                                color: widget.experience.isPreWarmed ? AppTheme.accentEmerald : AppTheme.textMuted,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Practice and Duration Info at bottom of image
                    Positioned(
                      bottom: 8,
                      left: 10,
                      right: 10,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.experience.practice,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: AppTheme.primaryCyan, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            widget.experience.duration,
                            style: const TextStyle(color: Colors.white70, fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Content Details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.experience.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.experience.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 11,
                            height: 1.25,
                          ),
                        ),

                        const Spacer(),

                        // Tags
                        Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          children: widget.experience.tags.take(2).map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '#$tag',
                                style: const TextStyle(color: AppTheme.textMuted, fontSize: 9, fontWeight: FontWeight.w500),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 8),

                        // Action Buttons Footer
                        Row(
                          children: [
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              onPressed: () => _showMetadataDialog(context, widget.experience),
                              icon: const Icon(Icons.info_outline, color: AppTheme.textSecondary, size: 18),
                              tooltip: 'View Metadata & Config',
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: typeColor,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  elevation: 1,
                                ),
                                onPressed: () => provider.launchExperience(widget.experience),
                                icon: Icon(_getTypeIcon(widget.experience.type), size: 16),
                                label: Text(
                                  widget.experience.actionLabel,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMetadataDialog(BuildContext context, Experience exp) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(exp.title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _infoRow('ID:', exp.id),
              _infoRow('Practice:', exp.practice),
              _infoRow('Industry:', exp.industry),
              _infoRow('Capability:', exp.capability),
              _infoRow('Runtime Type:', exp.typeLabel),
              _infoRow('Version:', exp.version),
              _infoRow('Owner:', exp.owner),
              _infoRow('Certification Status:', exp.status.name.toUpperCase()),
              _infoRow('Security Score:', '${exp.securityScore}%'),
              const SizedBox(height: 10),
              const Text('Business Problem:', style: TextStyle(color: AppTheme.primaryCyan, fontWeight: FontWeight.bold, fontSize: 12)),
              Text(exp.businessProblem, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 8),
              const Text('Business Outcome:', style: TextStyle(color: AppTheme.accentEmerald, fontWeight: FontWeight.bold, fontSize: 12)),
              Text(exp.businessOutcome, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 8),
              const Text('Technology Stack:', style: TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
              Text(exp.technology, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(color: AppTheme.primaryCyan)),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
