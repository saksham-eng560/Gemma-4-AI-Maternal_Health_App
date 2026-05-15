# Maternal Health AI

Offline AI-powered maternal healthcare assistant built using Flutter, Gemma, and LiteRT.

## Live Demo

🌐 Web App: https://admirable-beignet-1e4659.netlify.app

📱 APK Download: https://github.com/saksham-eng560/Gemma-4-AI-Maternal_Health_App/releases/tag/v1.0

🎥 Demo Video: https://youtu.be/qY21dcE8Qlo

---

## Problem Statement

Pregnant women in rural and low-connectivity regions often lack immediate medical guidance and early risk assessment. Many complications go unnoticed due to poor internet access, shortage of healthcare workers, and delayed medical intervention.

Maternal Health AI aims to provide accessible and offline-first healthcare assistance using AI.

---

## Solution

Maternal Health AI allows users to:

- Describe symptoms using voice input
- Upload visual evidence for analysis
- Receive offline AI-powered risk assessment
- Get emergency guidance and escalation support
- Access multilingual interaction support
- Use the platform without internet connectivity

The application performs on-device inference using Gemma and LiteRT/TensorFlow Lite, making it suitable for remote and underserved communities.

---

## Features

- Offline AI support
- Voice symptom recording
- Image upload and analysis
- Maternal risk-level detection
- Emergency escalation workflow
- Android + Web support
- Lightweight and responsive UI
- Multilingual accessibility

---

## Tech Stack

- Flutter
- Dart
- Gemma
- LiteRT / TensorFlow Lite
- Firebase (optional)
- Android Studio
- VS Code

---

## Architecture

1. User provides symptoms through voice or text
2. Images are uploaded for visual analysis
3. Gemma processes symptom and image data offline
4. LiteRT performs on-device inference
5. Risk level and emergency recommendations are generated
6. User receives guidance and referral suggestions

---

## Installation

### Clone Repository

```bash
git clone https://github.com/yourusername/repository.git
cd repository
```

### Install Dependencies

```bash
flutter pub get
```

### Run Application

```bash
flutter run
```

---

## Build APK

```bash
flutter build apk --release
```

APK output location:

```bash
build/app/outputs/flutter-apk/app-release.apk
```

---

## Build Web Version

```bash
flutter build web
```

---

## Future Scope

- Local dialect voice output
- Nearby healthcare center integration
- SMS emergency alerts
- Improved multimodal analysis
- Real-time maternal monitoring
- Expanded language support

---

## Impact

Maternal Health AI focuses on improving maternal healthcare accessibility in underserved regions by providing fast, reliable, and offline medical assistance powered by AI.

The project combines healthcare impact, offline accessibility, multimodal AI, and mobile deployment into a scalable solution for real-world use cases.

---

## Builder

Saksham Verma

---

## License

MIT License
