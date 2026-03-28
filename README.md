# HealthTrace - Health Tech Mobile Application

A **production-ready Flutter mobile application** for health tracking and medical report management, built with **Clean Architecture** and ready for seamless backend integration.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-orange)

## 🎯 Overview

HealthTrace is a comprehensive health management application that enables users to:
- Upload and manage medical reports
- Track health metrics and trends
- Share health summaries with doctors
- Monitor abnormal health parameters
- Maintain a complete health profile

## 🌟 Key Features

### ✅ Implemented Features
- **Authentication System** (Login, Signup, OTP, Password Reset)
- **Health Dashboard** with key metrics and abnormal parameters
- **Report Management** (Upload, Extract, Verify)
- **Trends Analytics** with graphical representations
- **Doctor Visit Flow** with AI summary generation
- **User Profile & Settings** management
- **Dark Mode Support**
- **Responsive Design** (Mobile & Tablet)
- **Mock Data for Development** (Easy backend integration)

### 🔄 Core Architecture
- ✅ **Clean Architecture** (3-layer separation)
- ✅ **MVVM/Provider Pattern** with Riverpod
- ✅ **Repository Pattern** for data abstraction
- ✅ **Dependency Injection** via Providers
- ✅ **GoRouter** for navigation
- ✅ **Material Design 3** UI components
- ✅ **Comprehensive Theming** system

## 🏗️ Project Structure

```
HealthTrace-Flutter/
├── lib/src/
│   ├── presentation/          # UI Layer
│   │   ├── screens/          # Full pages
│   │   ├── widgets/          # Reusable components
│   │   ├── providers/        # State management
│   │   └── routes/           # Navigation
│   ├── domain/               # Business Logic (Framework-Independent)
│   │   ├── entities/         # Business objects
│   │   ├── repositories/     # Interfaces
│   │   └── usecases/         # Business operations
│   ├── data/                 # Data & API Layer
│   │   ├── datasources/      # Remote & Local sources
│   │   ├── models/           # DTOs for API
│   │   └── repositories/     # Implementations
│   └── core/                 # Shared Utilities
│       ├── theme/            # Design system
│       ├── constants/        # App constants
│       ├── utils/            # Validators, loggers
│       └── extensions/       # Dart extensions
├── pubspec.yaml              # Dependencies
├── ARCHITECTURE.md           # Detailed architecture guide
├── GETTING_STARTED.md        # Quick start guide
└── README.md                 # This file
```

## 🚀 Quick Start

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable — includes Dart)
- Android Studio / Xcode (for emulator/simulator) **or** a physical device
- Git

---

### Option A — One-command setup (recommended)

Clone the repo, then run the setup script for your platform. It will install all dependencies and generate required code automatically.

#### Windows (PowerShell)
```powershell
git clone <your-repo-url>
cd HealthTrace-Flutter
.\setup.ps1
```

> If you see a permissions error, first run:
> ```powershell
> Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
> ```

#### macOS / Linux (Bash)
```bash
git clone <your-repo-url>
cd HealthTrace-Flutter
chmod +x setup.sh
./setup.sh
```

After the script finishes, launch the app:
```bash
flutter run
```

---

### Option B — Manual setup

```bash
# 1. Navigate to project
cd HealthTrace-Flutter

# 2. Get dependencies
flutter pub get

# 3. Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Run app
flutter run
```

## 📦 Dependencies

### State Management
- **flutter_riverpod** (v2.4.0) - Advanced state management

### Navigation
- **go_router** (v13.0.0) - Type-safe routing

### Networking
- **dio** (v5.4.0) - HTTP client
- **retrofit** (v4.1.0) - API client generator
- **json_serializable** (v6.7.0) - JSON serialization

### Storage
- **shared_preferences** (v2.2.0) - Persistent storage
- **hive** (v2.2.0) - Local database

### Models
- **freezed_annotation** (v2.4.1) - Immutable models
- **json_annotation** (v4.8.0) - JSON mapping

### UI/UX
- **flutter_svg** (v2.0.0) - SVG support
- **cached_network_image** (v3.3.0) - Image caching
- **intl** (v0.19.0) - Internationalization

### Utilities
- **get_it** (v7.6.0) - Service locator
- **logger** (v2.1.0) - Logging
- **uuid** (v4.0.0) - ID generation

## 🔑 Architecture Highlights

### Clean Architecture Layers

```
┌─────────────────────────────────────┐
│       PRESENTATION LAYER            │
│  (Screens, Widgets, Providers)      │
└──────────────────┬──────────────────┘
                   │
┌──────────────────▼──────────────────┐
│        DOMAIN LAYER                 │
│  (Entities, Repositories, Usecases) │
│  (Framework Independent)            │
└──────────────────┬──────────────────┘
                   │
┌──────────────────▼──────────────────┐
│         DATA LAYER                  │
│ (Services, Datasources, Models)     │
└──────────────────┬──────────────────┘
                   │
┌──────────────────▼──────────────────┐
│    EXTERNAL SERVICES & STORAGE      │
│   (APIs, Databases, Cache)          │
└─────────────────────────────────────┘
```

### State Management with Riverpod

```dart
// Service providers (Dependency Injection)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(...);
});

// State management
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(...);
});

// Usage in UI
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authStateProvider);
    return Text('Auth State: ${state.isAuthenticated}');
  }
}
```

## 🔌 Backend Integration

The project is designed for easy backend integration:

### Current Setup (Mock Data)
```dart
final authRemoteDataSourceProvider = 
  Provider<AuthRemoteDataSource>((ref) => MockAuthRemoteDataSource());
```

### To Connect Real API

```dart
// 1. Create API client with Retrofit
@RestApi(baseUrl: 'https://api.healthtrace.com/v1')
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio) = _AuthApiClient;
  
  @POST('/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);
}

// 2. Update provider
final authRemoteDataSourceProvider = 
  Provider<AuthRemoteDataSource>((ref) {
    final dio = Dio();
    return RealAuthRemoteDataSource(AuthApiClient(dio));
  });

// 3. Update API constants
class ApiConstants {
  static const String baseUrl = 'https://your-api.com/v1';
}
```

See `ARCHITECTURE.md` for detailed integration guide.

## 🎨 Theming

The app supports light and dark modes with a comprehensive design system:

```dart
// Colors
AppColors.primaryColor
AppColors.secondaryColor
AppColors.errorColor
// ... and more

// Typography
AppTypography.displayLarge
AppTypography.headlineSmall
AppTypography.bodyMedium
// ... and more

// Spacing
AppSpacing.xs  // 4
AppSpacing.sm  // 8
AppSpacing.lg  // 16
// ... and more
```

## 📱 Screen Templates

All screens follow this structure:

```dart
class MyScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myProvider);
    
    return Scaffold(
      appBar: AppBar(title: Text('My Screen')),
      body: state.when(
        data: (data) => _buildContent(data),
        loading: () => const AppLoadingIndicator(),
        error: (error, _) => AppErrorWidget(message: error.toString()),
      ),
    );
  }
}
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/domain/usecases/login_usecase_test.dart

# Run with coverage
flutter test --coverage
```

## 📚 Documentation

- **[ARCHITECTURE.md](./ARCHITECTURE.md)** - Detailed architecture explanation, patterns, and integration guide
- **[GETTING_STARTED.md](./GETTING_STARTED.md)** - Quick start guide with examples
- [Flutter Documentation](https://flutter.dev)
- [Riverpod Documentation](https://riverpod.dev)
- [GoRouter Documentation](https://pub.dev/packages/go_router)

## 📝 Code Examples

### Authentication Flow

```dart
// Login
Future<void> _login() async {
  final loginUseCase = ref.read(loginUseCaseProvider);
  
  try {
    final (accessToken, refreshToken) = await loginUseCase(
      email: 'user@example.com',
      password: 'password123',
    );
    // Navigation happens automatically via state listener
  } catch (e) {
    // Handle error
  }
}
```

### Managing User State

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authStateProvider, (prev, next) {
      if (!next.isAuthenticated) {
        context.go('/auth/login');
      }
    });
    
    final user = ref.watch(
      authStateProvider.select((state) => state.user)
    );
    
    return Text('Hello, $user');
  }
}
```

### Creating Reusable Widgets

```dart
class AppCard extends StatelessWidget {
  final Widget child;
  
  const AppCard({Key? key, required this.child}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: child,
      ),
    );
  }
}
```

## 🛠️ Development Checklist

- [ ] Explore the clean architecture structure
- [ ] Understand the state management setup
- [ ] Modify theme colors in `app_theme_constants.dart`
- [ ] Add a new screen following the templates
- [ ] Implement a new feature (entity + repository + provider + screen)
- [ ] Replace mock datasources with real API calls
- [ ] Set up secure token storage
- [ ] Add unit and widget tests
- [ ] Configure push notifications
- [ ] Set up analytics/crash reporting
- [ ] Prepare for app store releases

## 🔒 Security Best Practices

- ✅ Use secure storage for tokens (flutter_secure_storage)
- ✅ Implement HTTPS for all API calls
- ✅ Validate all user inputs
- ✅ Don't hardcode API keys
- ✅ Implement proper error messages (no sensitive info)
- ✅ Use token refresh mechanism
- ✅ Implement logout functionality

## 📦 Building for Production

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

When extending the project:

1. Follow the clean architecture structure
2. Use consistent naming conventions
3. Add tests for new features
4. Update documentation
5. Keep components modular

## 📄 License

This project is open source and available under the MIT License. See LICENSE file for details.

## 🆘 Troubleshooting

### Build Issues
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Hot Reload Not Working
```bash
flutter run --no-fast-start
```

### Dependency Conflicts
```bash
flutter pub upgrade
flutter pub get
```

## 🙏 Support

For issues or questions:
1. Check the documentation files
2. Review the example screens
3. Consult Riverpod and GoRouter docs
4. Refer to comments in the codebase

## 🚀 Roadmap

- [ ] Multi-language support (Localization)
- [ ] Advanced analytics dashboard
- [ ] Offline-first functionality
- [ ] AI-powered health insights
- [ ] Voice-based report descriptions
- [ ] Social health sharing features
- [ ] Integration with wearables API
- [ ] Advanced charts and visualizations

---

**Ready to build amazing health tech? Get started with HealthTrace! 🏥📱**

Made with ❤️ using Flutter and Riverpod
