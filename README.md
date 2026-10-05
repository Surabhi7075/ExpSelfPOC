# Experience Centre OS

**Experience Centre OS** is an always-available, touch-first, intuitive, and AI-native operating system designed for discovering, managing, testing, deploying, and experiencing client capabilities across Experience Centres.

It supports cross-platform deployment across **Android**, **iOS**, and **Web**, with responsive layouts optimized for Mobile, Tablet, Smart Touch Displays, and Kiosks.

---

## 🚀 Experience Centre OS Key Features

- **🎬 Media Experience Player**: High-definition video player with local pre-warming, presenter controls, speed adjustments, and "Handover Control to Client" touch mode.
- **🌐 Interactive Web Sandbox**: Embedded browser simulator with device resolution toggles (Desktop, Touch Kiosk, Tablet, Mobile) and microservices topology graph.
- **🐳 Docker Container Execution Sandbox**: Simulated local container runner with real-time log streaming, CPU/RAM usage meters, and RSA signature certification verification.
- **🤖 Agentic AI Assistant & Multi-Agent Workflows**: Interactive autonomous agent chat pipeline for financial risk, code transformation, and compliance reporting.
- **🔍 AI Semantic & Voice Search**: Instant voice search simulation with intent detection and automated catalog filtering.
- **⚙️ Governance & Lifecycle Pipeline**: Practice Contributor and Administrator dashboard for packaging experiences through `DRAFT ➔ TESTING ➔ CERTIFICATION ➔ PUBLISHED`.
- **💾 Local Registry & Offline Architecture**: Zero-latency local SSD caching, offline capability matrix, and pre-warming manager.

---

## 📱 How to Run Experience Centre OS

### Prerequisites
1. Ensure [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.0+) is installed.
2. Verify Flutter dependencies:
   ```bash
   flutter doctor
   ```

### 1. Run on Web (Google Chrome / Safari / Edge)
To run in Chrome with hot reload:
```bash
flutter run -d chrome
```
To build web production bundle:
```bash
flutter build web --release
```

### 2. Run on Android (Device / Tablet / Touch Kiosk / Emulator)
1. Connect your Android device or start an Android Emulator.
2. Run:
```bash
flutter run -d android
```
To build Android APK:
```bash
flutter build apk --release
```

### 3. Run on iOS (iPhone / iPad / Simulator)
1. Open iOS Simulator or connect physical iOS device.
2. Run:
```bash
flutter run -d ios
```
To build iOS release archive:
```bash
flutter build ipa --release
```

### 4. Run on macOS / Desktop
```bash
flutter run -d macos
```

---

## 🎨 Responsive Design Architecture

Experience Centre OS automatically adapts to any screen width:
- **Mobile Phones (< 650px)**: Bottom Navigation Dock, compact card layout, sliding modal drawers.
- **Tablets & Touch Displays (650px - 1100px)**: Dual-pane view with side dock and 2-column grid.
- **Desktops & Full Kiosks (> 1100px)**: Multi-stage OS layout, side navigation, metadata sidebar, and 3/4-column card matrix.
