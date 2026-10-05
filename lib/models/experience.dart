enum ExperienceType {
  media,
  interactiveWeb,
  container,
  agentic,
}

enum LifecycleStatus {
  draft,
  testing,
  certification,
  published,
  updateAvailable,
  retired,
}

enum UserRole {
  presenter,
  practiceContributor,
  practiceAdmin,
  centreAdmin,
  platformAdmin,
}

class Experience {
  final String id;
  final String title;
  final String description;
  final String practice;
  final String capability;
  final String industry;
  final String businessProblem;
  final String businessOutcome;
  final String technology;
  final List<String> tags;
  final String imageUrl;
  final ExperienceType type;
  final String contentUrl; // Video URL, Web URL, Docker Image tag, or Agent Endpoint
  final String duration;
  final String version;
  final String owner;
  LifecycleStatus status;
  bool isPreWarmed;
  bool isCachedLocally;
  int playCount;
  final double securityScore;

  Experience({
    required this.id,
    required this.title,
    required this.description,
    required this.practice,
    required this.capability,
    required this.industry,
    required this.businessProblem,
    required this.businessOutcome,
    required this.technology,
    required this.tags,
    required this.imageUrl,
    required this.type,
    required this.contentUrl,
    required this.duration,
    required this.version,
    required this.owner,
    required this.status,
    this.isPreWarmed = false,
    this.isCachedLocally = true,
    this.playCount = 0,
    this.securityScore = 98.5,
  });

  String get typeLabel {
    switch (type) {
      case ExperienceType.media:
        return 'Media (Video/PDF)';
      case ExperienceType.interactiveWeb:
        return 'Interactive Web';
      case ExperienceType.container:
        return 'Docker Container';
      case ExperienceType.agentic:
        return 'Agentic AI';
    }
  }

  String get actionLabel {
    switch (type) {
      case ExperienceType.media:
        return 'Play Experience';
      case ExperienceType.interactiveWeb:
        return 'Launch App';
      case ExperienceType.container:
        return 'Run Container';
      case ExperienceType.agentic:
        return 'Launch Agent';
    }
  }
}
