import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/experience_provider.dart';
import 'theme/app_theme.dart';
import 'views/agentic_view.dart';
import 'views/discovery_view.dart';
import 'views/docker_runner_view.dart';
import 'views/interactive_web_view.dart';
import 'views/local_registry_view.dart';
import 'views/management_view.dart';
import 'views/media_player_view.dart';
import 'widgets/os_bottom_nav.dart';
import 'widgets/os_sidebar.dart';
import 'widgets/os_top_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ExperienceCentreOSApp());
}

class ExperienceCentreOSApp extends StatelessWidget {
  const ExperienceCentreOSApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ExperienceProvider(),
      child: MaterialApp(
        title: 'Experience Centre OS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const ExperienceCentreOSHome(),
      ),
    );
  }
}

class ExperienceCentreOSHome extends StatelessWidget {
  const ExperienceCentreOSHome({Key? key}) : super(key: key);

  Widget _buildActiveView(int navIndex) {
    switch (navIndex) {
      case 0:
        return const DiscoveryView();
      case 1:
        return const MediaPlayerView();
      case 2:
        return const InteractiveWebView();
      case 3:
        return const DockerRunnerView();
      case 4:
        return const AgenticView();
      case 5:
        return const ManagementView();
      case 6:
        return const LocalRegistryView();
      default:
        return const DiscoveryView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExperienceProvider>(context);
    final isMobile = AppTheme.isMobile(context);

    return Scaffold(
      appBar: const OsTopBar(),
      body: Row(
        children: [
          // Desktop & Tablet Side Dock Navigation
          if (!isMobile) const OsSidebar(),

          // Main OS Stage Area
          Expanded(
            child: Container(
              color: AppTheme.background,
              child: _buildActiveView(provider.activeNavIndex),
            ),
          ),
        ],
      ),
      // Mobile Bottom Bar Navigation
      bottomNavigationBar: isMobile ? const OsBottomNav() : null,
    );
  }
}
