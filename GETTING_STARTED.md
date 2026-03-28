# HealthTrace Flutter - Getting Started Guide

Welcome to the HealthTrace Flutter application! This guide will help you get started with the project.

## 📥 Quick Start

### 1. **Clone/Extract the Project**
```bash
cd HealthTrace-Flutter
```

### 2. **Install Dependencies**
```bash
flutter pub get
```

### 3. **Generate Code (Important!)**
```bash
flutter pub run build_runner build
```

### 4. **Run the Application**
```bash
flutter run
```

## 🎯 Key Files to Explore

### Entry Point
- **`lib/main.dart`** - Application entry point with Riverpod setup

### Architecture Examples

1. **Authentication Flow**
   - Domain: `lib/src/domain/entities/user.dart`, `lib/src/domain/repositories/auth_repository.dart`
   - Data: `lib/src/data/datasources/auth_datasource.dart`
   - Presentation: `lib/src/presentation/screens/login_screen.dart`

2. **Theme & Styling**
   - `lib/src/core/theme/app_theme.dart` - Theme configuration
   - `lib/src/core/theme/app_theme_constants.dart` - Colors, spacing, typography

3. **State Management**
   - `lib/src/presentation/providers/auth_providers.dart` - Riverpod setup for auth

4. **Routing**
   - `lib/src/presentation/routes/app_router.dart` - GoRouter configuration

## 🏗️ Folder Structure Quick Reference

```
lib/src/
├── presentation/         ← UI Components & Screens
│   ├── screens/         ← Full page screens
│   ├── widgets/         ← Reusable UI components
│   ├── providers/       ← Riverpod state management
│   └── routes/          ← Navigation setup
├── domain/              ← Business Logic (Independent)
│   ├── entities/        ← Data models
│   ├── repositories/    ← Interfaces
│   └── usecases/        ← Business operations
├── data/                ← API & Storage Implementation
│   ├── datasources/     ← API clients & local storage
│   ├── models/          ← DTOs for JSON conversion
│   └── repositories/    ← Implementation of domain interfaces
└── core/                ← Shared Utilities
    ├── theme/           ← Design system
    ├── constants/       ← App strings, API endpoints
    ├── utils/           ← Validators, loggers
    └── extensions/      ← Dart extensions
```

## 🔑 Core Concepts

### 1. **Entities** (Domain Layer)
Pure business objects without any framework dependencies.

```dart
// Example: User entity
class User {
  final String id;
  final String email;
  final String name;
}
```

### 2. **Repositories** (Abstraction)
Define contracts for data operations.

```dart
abstract class AuthRepository {
  Future<User> login(String email, String password);
}
```

### 3. **Data Models** (Data Layer)
Convert API responses to app entities.

```dart
class UserModel {
  final String id;
  final String email;
  
  User toEntity() => User(id: id, email: email);
}
```

### 4. **Providers** (State Management)
Manage app state with Riverpod.

```dart
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>(...);
```

### 5. **Screens** (Presentation)
UI that watches providers for updates.

```dart
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
  }
}
```

## 💡 Adding a New Screen

### Example: Adding a Health Tips Screen

```dart
// Step 1: Create the entity (domain/entities/health_tip.dart)
class HealthTip {
  final String id;
  final String title;
  final String description;
}

// Step 2: Create repository interface (domain/repositories/health_repository.dart)
abstract class HealthRepository {
  Future<List<HealthTip>> getHealthTips();
}

// Step 3: Create mock datasource (data/datasources/health_datasource.dart)
class MockHealthRemoteDataSource {
  Future<List<HealthTipModel>> fetchHealthTips() async {
    // Return mock data
  }
}

// Step 4: Implement repository (data/repositories/health_repository_impl.dart)
class HealthRepositoryImpl implements HealthRepository {
  // Implementation
}

// Step 5: Create providers (presentation/providers/health_providers.dart)
final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepositoryImpl(...);
});

// Step 6: Create screen (presentation/screens/health_tips_screen.dart)
class HealthTipsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Implementation
  }
}

// Step 7: Add route (presentation/routes/app_router.dart)
GoRoute(
  path: '/health-tips',
  builder: (context, state) => const HealthTipsScreen(),
)
```

## 🔌 Connecting to Real Backend

When ready to connect to real APIs:

1. **Replace Mock Data Sources**
   - Create real API client with Retrofit
   - Update datasource to use actual HTTP calls

2. **Update Configuration**
   - Change `ApiConstants.baseUrl` to your server
   - Update API endpoints

3. **Add Error Handling**
   - Create custom exception classes
   - Handle different HTTP status codes

4. **Secure Token Management**
   - Use `flutter_secure_storage` for production
   - Implement token refresh logic

Example:
```dart
// Before: Mock
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return MockAuthRemoteDataSource();
});

// After: Real API
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = Dio();
  return RealAuthRemoteDataSource(AuthApiClient(dio));
});
```

## 🎨 Customizing Theme

Update colors and typography in `lib/src/core/theme/`:

```dart
// app_theme_constants.dart
class AppColors {
  static const Color primaryColor = Color(0xFF6366F1); // Change this
}

class AppTypography {
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );
}
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit_test.dart

# Run with coverage (requires lcov)
flutter test --coverage
```

## 📚 Useful Commands

```bash
# Format code
flutter format lib/

# Analyze code
flutter analyze

# Generate code
flutter pub run build_runner build

# Clean build
flutter clean && flutter pub get

# Run on specific device
flutter run -d <device_id>

# Create release build
flutter build apk --release  # Android
flutter build ios --release  # iOS
```

## 🐛 Common Issues

### Issue: Build errors after pulling changes
**Solution:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Issue: GoRouter not navigating
**Solution:**
- Check route paths match in `app_router.dart`
- Verify auth state is correct
- Check redirect logic in GoRouter

### Issue: Provider not updating UI
**Solution:**
- Use `watch()` not `read()`
- Ensure State changes call `state = newState;`
- Check provider dependencies

## 📖 Documentation

- **Architecture Detailed**: See `ARCHITECTURE.md`
- **API Integration**: See "Backend Integration" section in `ARCHITECTURE.md`
- **Riverpod Docs**: https://riverpod.dev
- **GoRouter Docs**: https://pub.dev/packages/go_router
- **Flutter Docs**: https://flutter.dev/docs

## 🚀 Next Steps

1. **Explore the codebase** - Start with `lib/main.dart`
2. **Try modifying** - Change colors in `app_theme.dart`
3. **Add a feature** - Create a new repository and screen
4. **Connect your API** - Replace mock datasources with real ones
5. **Test the app** - Use `flutter test` for unit tests

## 💬 Need Help?

Refer to:
- `ARCHITECTURE.md` for detailed architecture explanation
- Comments in code files for specific implementations
- Flutter & Riverpod official documentation

---

**Happy coding! Build great health tech with Flutter! 🏥📱**
