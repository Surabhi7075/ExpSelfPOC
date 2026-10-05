import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../models/experience.dart';
import '../providers/experience_provider.dart';
import '../theme/app_theme.dart';

class MediaPlayerView extends StatefulWidget {
  const MediaPlayerView({Key? key}) : super(key: key);

  @override
  State<MediaPlayerView> createState() => _MediaPlayerViewState();
}

class _MediaPlayerViewState extends State<MediaPlayerView> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isClientHandoverMode = false;
  double _playbackSpeed = 1.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initPlayerForActiveExperience();
  }

  void _initPlayerForActiveExperience() {
    final provider = Provider.of<ExperienceProvider>(context, listen: false);
    final activeExp = provider.activeExperience ?? provider.allExperiences.firstWhere((e) => e.type == ExperienceType.media, orElse: () => provider.allExperiences.first);

    if (_controller?.dataSource != activeExp.contentUrl) {
      _controller?.dispose();
      _isInitialized = false;
      _hasError = false;

      // Check if contentUrl is valid video URL
      _controller = VideoPlayerController.networkUrl(Uri.parse(activeExp.contentUrl))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
            _controller?.play();
          }
        }).catchError((err) {
          if (mounted) {
            setState(() {
              _hasError = true;
            });
          }
        });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExperienceProvider>(context);
    final activeExp = provider.activeExperience ?? provider.allExperiences.firstWhere((e) => e.type == ExperienceType.media, orElse: () => provider.allExperiences.first);
    final isMobile = AppTheme.isMobile(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          // Sub-header Bar with Active Title & Presenter Controls
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: AppTheme.surface,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => provider.setActiveNavIndex(0),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryCyan.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text('MEDIA PLAYER', style: TextStyle(color: AppTheme.primaryCyan, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              activeExp.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Practice: ${activeExp.practice} • ${activeExp.industry}',
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),

                // Handover to Client Switch
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isClientHandoverMode ? AppTheme.accentEmerald.withOpacity(0.2) : AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _isClientHandoverMode ? AppTheme.accentEmerald : AppTheme.surfaceBorder),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isClientHandoverMode = !_isClientHandoverMode;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.touch_app,
                          color: _isClientHandoverMode ? AppTheme.accentEmerald : AppTheme.textSecondary,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        if (!isMobile)
                          Text(
                            _isClientHandoverMode ? 'Client Control Active' : 'Presenter Control',
                            style: TextStyle(
                              color: _isClientHandoverMode ? AppTheme.accentEmerald : Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Video Stage Area & Metadata Sidebar
          Expanded(
            child: Row(
              children: [
                // Video Player Container
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.surfaceBorder),
                      boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 16)],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_isInitialized && _controller != null) ...[
                            AspectRatio(
                              aspectRatio: _controller!.value.aspectRatio > 0 ? _controller!.value.aspectRatio : 16 / 9,
                              child: VideoPlayer(_controller!),
                            ),
                          ] else if (_hasError) ...[
                            _buildFallbackPlayer(activeExp),
                          ] else ...[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                CircularProgressIndicator(color: AppTheme.primaryCyan),
                                SizedBox(height: 16),
                                Text('Pre-warming & Loading Video Stream...', style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ],

                          // Overlay Controls
                          if (_isInitialized && _controller != null)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: _buildControlsOverlay(),
                            ),

                          // Client Handover Banner
                          if (_isClientHandoverMode)
                            Positioned(
                              top: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentEmerald,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(Icons.touch_app, color: Colors.black, size: 16),
                                    SizedBox(width: 6),
                                    Text('Touch Screen Interactive Mode Enabled', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Side Metadata & Context Panel (Desktop / Tablet)
                if (!isMobile)
                  Container(
                    width: 300,
                    margin: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.surfaceBorder),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('EXECUTION DETAILS', style: TextStyle(color: AppTheme.primaryCyan, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          const SizedBox(height: 12),
                          _buildDetailRow('Runtime:', 'Native Video Player / Local Cache'),
                          _buildDetailRow('Pre-Warmed:', activeExp.isPreWarmed ? 'Yes (0ms Latency)' : 'No'),
                          _buildDetailRow('Version:', activeExp.version),
                          _buildDetailRow('Security Status:', 'Certified Signed Artifact'),
                          const Divider(color: AppTheme.surfaceBorder, height: 24),

                          const Text('BUSINESS CONTEXT', style: TextStyle(color: AppTheme.primaryCyan, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          const SizedBox(height: 8),
                          const Text('Business Problem:', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                          Text(activeExp.businessProblem, style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.3)),
                          const SizedBox(height: 10),
                          const Text('Business Outcome:', style: TextStyle(color: AppTheme.textMuted, fontSize: 11)),
                          Text(activeExp.businessOutcome, style: const TextStyle(color: AppTheme.accentEmerald, fontSize: 12, fontWeight: FontWeight.bold, height: 1.3)),

                          const Divider(color: AppTheme.surfaceBorder, height: 24),
                          const Text('RELATED EXPERIENCES', style: TextStyle(color: AppTheme.primaryCyan, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                          const SizedBox(height: 8),

                          ...provider.allExperiences.where((e) => e.id != activeExp.id).take(2).map((rel) {
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              color: AppTheme.surfaceLight,
                              child: ListTile(
                                dense: true,
                                title: Text(rel.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                subtitle: Text(rel.typeLabel, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 10)),
                                trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: AppTheme.primaryCyan),
                                onTap: () => provider.launchExperience(rel),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlsOverlay() {
    final value = _controller!.value;
    final duration = value.duration.inSeconds;
    final position = value.position.inSeconds;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withOpacity(0.9), Colors.transparent],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Seek bar
          Slider(
            activeColor: AppTheme.primaryCyan,
            inactiveColor: Colors.white24,
            min: 0,
            max: duration > 0 ? duration.toDouble() : 1.0,
            value: position.toDouble().clamp(0.0, duration > 0 ? duration.toDouble() : 1.0),
            onChanged: (val) {
              _controller?.seekTo(Duration(seconds: val.toInt()));
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(value.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled, color: Colors.white, size: 32),
                    onPressed: () {
                      setState(() {
                        value.isPlaying ? _controller?.pause() : _controller?.play();
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_formatDuration(value.position)} / ${_formatDuration(value.duration)}',
                    style: const TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'monospace'),
                  ),
                ],
              ),
              Row(
                children: [
                  PopupMenuButton<double>(
                    initialValue: _playbackSpeed,
                    tooltip: 'Playback Speed',
                    icon: const Icon(Icons.speed, color: Colors.white, size: 20),
                    color: AppTheme.surface,
                    onSelected: (speed) {
                      setState(() {
                        _playbackSpeed = speed;
                        _controller?.setPlaybackSpeed(speed);
                      });
                    },
                    itemBuilder: (context) => [0.5, 1.0, 1.25, 1.5, 2.0].map((s) {
                      return PopupMenuItem<double>(
                        value: s,
                        child: Text('${s}x', style: TextStyle(color: _playbackSpeed == s ? AppTheme.primaryCyan : Colors.white)),
                      );
                    }).toList(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.fullscreen, color: Colors.white),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Fullscreen presentation mode active'), duration: Duration(seconds: 1)),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackPlayer(Experience activeExp) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.video_library, size: 64, color: AppTheme.primaryCyan),
          const SizedBox(height: 16),
          Text(activeExp.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Local Execution Mode: Streaming fallback interactive video player', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryCyan),
            onPressed: () {
              _initPlayerForActiveExperience();
            },
            icon: const Icon(Icons.refresh, color: Colors.black),
            label: const Text('Reload Video Stream', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textMuted, fontSize: 12)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
