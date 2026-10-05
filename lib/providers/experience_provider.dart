import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/experience.dart';

class ExperienceProvider extends ChangeNotifier {
  UserRole _currentRole = UserRole.presenter;
  String _searchQuery = '';
  String _selectedPractice = 'All Practices';
  String _selectedIndustry = 'All Industries';
  ExperienceType? _selectedType;
  bool _isOfflineMode = false;
  bool _isVoiceSearching = false;
  Experience? _activeExperience;
  int _activeNavIndex = 0; // 0: Discovery, 1: Media Player, 2: Interactive Web, 3: Docker Runner, 4: Agentic AI, 5: Management, 6: Registry

  UserRole get currentRole => _currentRole;
  String get searchQuery => _searchQuery;
  String get selectedPractice => _selectedPractice;
  String get selectedIndustry => _selectedIndustry;
  ExperienceType? get selectedType => _selectedType;
  bool get isOfflineMode => _isOfflineMode;
  bool get isVoiceSearching => _isVoiceSearching;
  Experience? get activeExperience => _activeExperience;
  int get activeNavIndex => _activeNavIndex;

  void setRole(UserRole role) {
    _currentRole = role;
    notifyListeners();
  }

  void setActiveNavIndex(int index) {
    _activeNavIndex = index;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedPractice(String practice) {
    _selectedPractice = practice;
    notifyListeners();
  }

  void setSelectedIndustry(String industry) {
    _selectedIndustry = industry;
    notifyListeners();
  }

  void setSelectedType(ExperienceType? type) {
    _selectedType = type;
    notifyListeners();
  }

  void toggleOfflineMode() {
    _isOfflineMode = !_isOfflineMode;
    notifyListeners();
  }

  void setVoiceSearching(bool value) {
    _isVoiceSearching = value;
    notifyListeners();
  }

  void launchExperience(Experience exp) {
    _activeExperience = exp;
    exp.playCount += 1;

    switch (exp.type) {
      case ExperienceType.media:
        _activeNavIndex = 1;
        break;
      case ExperienceType.interactiveWeb:
        _activeNavIndex = 2;
        break;
      case ExperienceType.container:
        _activeNavIndex = 3;
        break;
      case ExperienceType.agentic:
        _activeNavIndex = 4;
        break;
    }
    notifyListeners();
  }

  void closeActiveExperience() {
    _activeExperience = null;
    notifyListeners();
  }

  final List<String> practicesList = [
    'All Practices',
    'Legacy Modernization',
    'Cloud Native',
    'GenAI & Automation',
    'Data & Analytics',
    'Cybersecurity',
  ];

  final List<String> industriesList = [
    'All Industries',
    'Banking & Financial Services',
    'Healthcare & Life Sciences',
    'Retail & E-commerce',
    'Manufacturing & Automotive',
    'Public Sector',
  ];

  // Initial Sample Seed Data from PRD
  final List<Experience> _experiences = [
    Experience(
      id: 'EXP-101',
      title: 'COBOL Modernization & Automated Transpilation',
      description: 'Demonstrates automated conversion of mainframe COBOL code into cloud-native Java Microservices with automated unit test generation.',
      practice: 'Legacy Modernization',
      capability: 'Code Transformation',
      industry: 'Banking & Financial Services',
      businessProblem: 'High cost and risk of legacy mainframe code maintenance',
      businessOutcome: '70% faster migration with 99.4% code functional equivalence',
      technology: 'Java, Spring Boot, LLM Transpiler, COBOL Engine',
      tags: ['COBOL', 'Legacy', 'Java', 'Migration', 'Automated Testing'],
      imageUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?auto=format&fit=crop&w=600&q=80',
      type: ExperienceType.media,
      contentUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      duration: '04:15',
      version: 'v2.4.0',
      owner: 'Mainframe Migration Practice',
      status: LifecycleStatus.published,
      isPreWarmed: true,
      isCachedLocally: true,
      playCount: 142,
    ),
    Experience(
      id: 'EXP-102',
      title: 'Agentic Financial Risk Assessment Copilot',
      description: 'Interactive multi-agent AI workflow that ingests financial statements, simulates stress tests, and builds real-time compliance reports.',
      practice: 'GenAI & Automation',
      capability: 'Multi-Agent Workflows',
      industry: 'Banking & Financial Services',
      businessProblem: 'Manual financial risk audits take weeks to assemble',
      businessOutcome: 'Real-time risk scoring and automated compliance dossier in under 2 minutes',
      technology: 'LangChain, AutoGen, Llama3, VectorDB',
      tags: ['AI Agent', 'GenAI', 'Risk Analysis', 'Banking', 'LLM'],
      imageUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=600&q=80',
      type: ExperienceType.agentic,
      contentUrl: 'https://agentic-risk-demo.internal/api',
      duration: 'Interactive Sandbox',
      version: 'v1.1.0',
      owner: 'AI & Automation Hub',
      status: LifecycleStatus.published,
      isPreWarmed: true,
      isCachedLocally: true,
      playCount: 98,
    ),
    Experience(
      id: 'EXP-103',
      title: 'Cloud Native Microservices Architecture Visualizer',
      description: 'Live interactive web application demonstrating elastic auto-scaling, chaos engineering, and distributed tracing across Kubernetes pods.',
      practice: 'Cloud Native',
      capability: 'Container Orchestration',
      industry: 'Manufacturing & Automotive',
      businessProblem: 'System outages during unexpected traffic bursts',
      businessOutcome: 'Zero-downtime deployment and dynamic scale up to 100k requests/sec',
      technology: 'Kubernetes, Istio, Prometheus, React, Flutter Web',
      tags: ['Kubernetes', 'Cloud Native', 'Microservices', 'Observability'],
      imageUrl: 'https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=600&q=80',
      type: ExperienceType.interactiveWeb,
      contentUrl: 'https://flutter.dev',
      duration: 'Live Simulator',
      version: 'v3.0.1',
      owner: 'Cloud Practice',
      status: LifecycleStatus.published,
      isPreWarmed: true,
      isCachedLocally: true,
      playCount: 210,
    ),
    Experience(
      id: 'EXP-104',
      title: 'AI Legacy Database Schema Migration Docker Sandbox',
      description: 'Executable Docker environment running automated Oracle DB to PostgreSQL schema and stored procedure translation.',
      practice: 'Legacy Modernization',
      capability: 'Database Modernization',
      industry: 'Healthcare & Life Sciences',
      businessProblem: 'Proprietary vendor lock-in and high licensing fees',
      businessOutcome: '65% license cost savings and automated data migration validation',
      technology: 'Docker, PostgreSQL, Oracle 19c, Python Migration Engine',
      tags: ['Docker', 'Database', 'Oracle', 'PostgreSQL', 'Migration'],
      imageUrl: 'https://images.unsplash.com/photo-1544383835-bda2bc66a55d?auto=format&fit=crop&w=600&q=80',
      type: ExperienceType.container,
      contentUrl: 'registry.experiencecentre.io/db-migrator:v1.2',
      duration: 'Local Docker Environment',
      version: 'v1.2.0',
      owner: 'Data Engineering Practice',
      status: LifecycleStatus.published,
      isPreWarmed: false,
      isCachedLocally: true,
      playCount: 64,
    ),
    Experience(
      id: 'EXP-105',
      title: 'Healthcare Patient Journey Analytics Overview',
      description: 'High-definition video presentation and PDF walkthrough of AI-driven patient triage and predictive bed allocation.',
      practice: 'Data & Analytics',
      capability: 'Predictive Analytics',
      industry: 'Healthcare & Life Sciences',
      businessProblem: 'Emergency room crowding and delayed patient admission',
      businessOutcome: '35% reduction in wait times and optimized resource usage',
      technology: 'TensorFlow, Healthcare Analytics, Flutter',
      tags: ['Healthcare', 'Predictive AI', 'Video', 'Analytics'],
      imageUrl: 'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&w=600&q=80',
      type: ExperienceType.media,
      contentUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      duration: '06:30',
      version: 'v1.0.0',
      owner: 'Healthcare Practice',
      status: LifecycleStatus.published,
      isPreWarmed: true,
      isCachedLocally: true,
      playCount: 88,
    ),
    Experience(
      id: 'EXP-106',
      title: 'Zero Trust Cybersecurity Threat Response Agent',
      description: 'Automated cybersecurity response agent simulating real-time ransomware isolation and autonomous policy distribution.',
      practice: 'Cybersecurity',
      capability: 'Threat Intelligence',
      industry: 'Retail & E-commerce',
      businessProblem: 'Delayed security patch distribution and lateral attack propagation',
      businessOutcome: 'Instant threat mitigation under 300 milliseconds',
      technology: 'eBPF, Zero Trust Framework, Agentic AI',
      tags: ['Security', 'Zero Trust', 'Agentic AI', 'Threat Defense'],
      imageUrl: 'https://images.unsplash.com/photo-1563986768609-322da13575f3?auto=format&fit=crop&w=600&q=80',
      type: ExperienceType.agentic,
      contentUrl: 'https://cyber-agent-demo.internal',
      duration: 'Interactive Agent Sandbox',
      version: 'v2.0.0',
      owner: 'Cybersecurity Practice',
      status: LifecycleStatus.testing,
      isPreWarmed: false,
      isCachedLocally: false,
      playCount: 15,
    ),
  ];

  List<Experience> get experiences {
    return _experiences.where((exp) {
      // Role filtering: Presenters only see certified & published experiences
      if (_currentRole == UserRole.presenter) {
        if (exp.status != LifecycleStatus.published) return false;
      }

      // Practice filter
      if (_selectedPractice != 'All Practices' && exp.practice != _selectedPractice) {
        return false;
      }

      // Industry filter
      if (_selectedIndustry != 'All Industries' && exp.industry != _selectedIndustry) {
        return false;
      }

      // Experience Type filter
      if (_selectedType != null && exp.type != _selectedType) {
        return false;
      }

      // Text / Semantic Search filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = exp.title.toLowerCase().contains(q);
        final matchesDesc = exp.description.toLowerCase().contains(q);
        final matchesTech = exp.technology.toLowerCase().contains(q);
        final matchesTags = exp.tags.any((t) => t.toLowerCase().contains(q));
        final matchesProblem = exp.businessProblem.toLowerCase().contains(q);
        return matchesTitle || matchesDesc || matchesTech || matchesTags || matchesProblem;
      }

      return true;
    }).toList();
  }

  List<Experience> get allExperiences => List.unmodifiable(_experiences);

  void addExperience(Experience exp) {
    _experiences.add(exp);
    notifyListeners();
  }

  void updateLifecycleStatus(String id, LifecycleStatus newStatus) {
    final idx = _experiences.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _experiences[idx].status = newStatus;
      notifyListeners();
    }
  }

  void togglePreWarm(String id) {
    final idx = _experiences.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _experiences[idx].isPreWarmed = !_experiences[idx].isPreWarmed;
      notifyListeners();
    }
  }

  void toggleLocalCache(String id) {
    final idx = _experiences.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _experiences[idx].isCachedLocally = !_experiences[idx].isCachedLocally;
      notifyListeners();
    }
  }
}
