# ThinkFlow - Smart Note-Taking App with AI

<div align="center">
  <img src="assets/logos/logo_foreground.png" alt="ThinkFlow Logo" width="120" height="120">
  <h3>Smart note-taking app with AI, helping you take notes, summarize and share efficiently</h3>
</div>

## 📱 Introduction

ThinkFlow is a smart note-taking application developed with Flutter, integrating AI features to help users create, manage, and share notes efficiently. The app supports various types of notes and uses AI to automatically summarize, convert speech to text, and create mind maps.

## ✨ Key Features

### 🔐 Authentication & Security
- **Sign up/Login** with email and password
- **Google Sign-in** integration
- **Email verification** with OTP
- **Forgot password** and reset functionality
- **Secure session management**

### 📝 Note Management
- **Create text notes** with rich text editor
- **Audio notes** with direct recording capability
- **Store and organize** notes by categories
- **Search and filter** notes
- **Archive** unused notes

### 🤖 AI Features
- **Automatic summarization** of text and audio
- **Speech-to-Text conversion**
- **Mind map generation** from note content
- **Text recognition from images** (OCR)

### 🎵 Audio Processing
- **Direct recording** within the app
- **Audio playback** with speed controls
- **Audio to text conversion**
- **Audio content summarization**

### 📊 Mind Mapping
- **Automatic mind map creation** from content
- **Edit and customize** mind maps
- **Zoom and navigate** mind maps
- **Export and share** mind maps

### 👥 Sharing & Collaboration
- **Share notes** via email
- **Create public sharing links**
- **Manage access permissions** (read/write)
- **Real-time sharing notifications**

### 🔔 Notifications
- **Push notifications** for important events
- **Local notifications** for activities
- **In-app notification management**

### 🎨 User Interface
- **Modern Material Design**
- **Dark/Light mode** customization
- **Responsive design** for all devices
- **Smooth animations** and great user experience

## 🛠 Technologies Used

### Frontend
- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language
- **BLoC Pattern** - State management
- **Auto Route** - Navigation and routing
- **GetX** - Dependency injection and state management

### Backend & API
- **RESTful API** - Server communication
- **Dio** - HTTP client
- **JSON** - Data serialization

### AI & Machine Learning
- **Google ML Kit** - Text recognition
- **Speech-to-Text** - Voice conversion
- **AI Summarization** - Content summarization
- **Mindmap Generation** - Mind map creation

### Media & Files
- **Just Audio** - Audio playback
- **Record** - Audio recording
- **Audio Waveforms** - Audio visualization
- **File Picker** - File selection
- **Image Picker** - Image selection
- **FFmpeg** - Media processing

### Authentication & Security
- **Firebase Authentication** - User authentication
- **Google Sign-In** - Google login
- **Shared Preferences** - Local storage

### Notifications
- **Firebase Messaging** - Push notifications
- **Flutter Local Notifications** - Local notifications

### UI/UX
- **Iconsax** - Icon library
- **Lottie** - Animations
- **Shimmer** - Loading effects
- **Flutter Quill** - Rich text editor
- **Mind Map** - Mind mapping

## 📱 Supported Platforms

- ✅ **Android** (API level 21+)
- ✅ **iOS** (iOS 12.0+)
- ✅ **Web** (Chrome, Firefox, Safari, Edge)
- ✅ **Desktop** (Windows, macOS, Linux)

## 🚀 Installation & Setup

### System Requirements
- **Flutter SDK** 3.6.2 or higher
- **Dart SDK** 3.0.0 or higher
- **Android Studio** / **VS Code**
- **Git**

### Step 1: Clone repository
```bash
git clone https://github.com/your-username/Think_Flow_App.git
cd Think_Flow_App
```

### Step 2: Install dependencies
```bash
flutter pub get
```

### Step 3: Configure Firebase (Optional)
1. Create a new Firebase project
2. Add Android/iOS app
3. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
4. Place in respective directories

### Step 4: Run the app
```bash
# Run on connected device
flutter run

# Build APK for Android
flutter build apk

# Build for iOS
flutter build ios
```

## 📁 Project Structure

```
lib/
├── app.dart                          # Application entry point
├── main.dart                         # Main function
├── firebase_options.dart             # Firebase configuration
├── generated/                        # Auto-generated files
├── common/                           # Shared widgets and components
│   ├── screens/                      # Common screens
│   └── widgets/                      # Reusable widgets
├── data/                             # Data layer
│   ├── data_sources/                 # Data sources
│   │   ├── local/                    # Local storage
│   │   └── remote/                   # API endpoints
│   ├── models/                       # Data models
│   └── repositories/                 # Repository pattern
├── presentation/                     # Presentation layer
│   ├── blocs/                        # BLoC state management
│   ├── router/                       # Navigation routing
│   └── screens/                      # UI screens
├── services/                         # Business logic services
└── utils/                            # Utilities and helpers
    ├── constants/                    # Constants
    ├── exceptions/                   # Exception handling
    ├── helpers/                      # Helper functions
    ├── theme/                        # App theme
    └── validators/                   # Form validation
```

## 🔧 API Configuration

The app uses RESTful API. Configure API endpoints in `lib/data/data_sources/remote/api_endpoint_urls.dart`:

```dart
class ApiEndpointUrls {
  static const String loginWithEmailAndPassword = "/auth/v1/authenticate";
  static const String loginWithGoogle = "/auth/v1/google/login";
  static const String signupWithEmailAndPassword = "/auth/v1/register";
  static const String note = "/note/v1/notes";
  static const String audio = "/media/v1/audios";
  // ... other endpoints
}
```

## 🎨 Theme and Styling

The app supports both light and dark modes with Material Design:

```dart
// Light theme
TAppTheme.lightTheme

// Dark theme  
TAppTheme.darkTheme
```

## 📊 State Management

Uses BLoC pattern for state management:

- **HomeBloc** - Main screen management
- **AuthBloc** - Authentication management
- **NoteBloc** - Note management
- **AudioBloc** - Audio management

## 🔐 Security

- **Token-based authentication**
- **Secure storage** for sensitive data
- **Input validation** and sanitization
- **HTTPS** for all API calls

## 📈 Performance

- **Lazy loading** for note lists
- **Image caching** with cached_network_image
- **Audio streaming** instead of full download
- **Optimized animations** and transitions

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test.dart

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## 📦 Build and Deploy

### Android
```bash
# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Build app bundle
flutter build appbundle
```

### iOS
```bash
# Build for iOS
flutter build ios --release
```

### Web
```bash
# Build for web
flutter build web
```

## 🤝 Contributing

We welcome all contributions! Please:

1. Fork the project
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

This project is distributed under the MIT License. See the `LICENSE` file for more details.

## 📞 Contact

- **Email**: support@thinkflow.com
- **Website**: https://thinkflow.com
- **GitHub**: https://github.com/your-username/Think_Flow_App

## 🙏 Acknowledgments

Thank you to all contributors who have contributed to the ThinkFlow project!

---

<div align="center">
  <p>Made with ❤️ by ThinkFlow Team</p>
  <p>Version 1.0.0+4</p>
</div>
