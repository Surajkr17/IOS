# HealthTrace Flutter Mobile Application

A production-ready Flutter health-tech mobile application following **Clean Architecture** principles with proper separation of concerns and ready for backend integration.

## 📋 Table of Contents

- [Architecture Overview](#architecture-overview)
- [Project Structure](#project-structure)
- [Installation & Setup](#installation--setup)
- [Features](#features)
- [State Management](#state-management)
- [Extending the Project](#extending-the-project)
- [Backend Integration](#backend-integration)
- [Testing](#testing)
- [Best Practices](#best-practices)

---

## 🏗️ Architecture Overview

This project follows **Clean Architecture** with three main layers:

### 1. **Presentation Layer** (`lib/src/presentation/`)
- UI/UX components and screens
- State management with **Riverpod**
- Navigation with **GoRouter**
- Reusable widgets and UI components
- Decoupled from business logic

### 2. **Domain Layer** (`lib/src/domain/`)
- Business entities (pure Dart objects)
- Repository interfaces (abstractions)
- Use cases (business logic)
- Framework/library independent

### 3. **Data Layer** (`lib/src/data/`)
- Repository implementations
- Data source implementations (remote + local)
- Models/DTOs (API data mapping)
- External service integrations

### 4. **Core Layer** (`lib/src/core/`)
- Theme and styling
- Constants and configuration
- Utilities and extensions
- Logger and error handling

```
Presentation Layer
       ↓
  (uses) Use Cases
       ↓
Domain Layer (Business Logic)
       ↓
Repository Interface
       ↓
Data Layer (Implementation)
       ↓
External Services & Local Storage
```

---

## 📁 Project Structure

```
lib/src/
├── presentation/          # UI Layer
│   ├── screens/          # Full-page screens
│   ├── pages/            # Page components within flows
│   ├── widgets/          # Reusable UI components
│   ├── providers/        # Riverpod state management
│   └── routes/           # Navigation routing
├── domain/               # Business Logic Layer
│   ├── entities/         # Business objects (User, Report, etc.)
│   ├── repositories/     # Repository interfaces
│   └── usecases/         # Business logic operations
├── data/                 # Data Layer
│   ├── repositories/     # Repository implementations
│   ├── datasources/      # Remote & local data sources
│   └── models/           # Data Transfer Objects (DTOs)
└── core/                 # Core Utilities
    ├── theme/           # Typography, colors, spacing
    ├── constants/       # App constants, strings, API endpoints
    ├── utils/           # Validation, logger, utilities
    └── extensions/      # Dart extension methods
```

---

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK (bundled with Flutter)
- Android Studio / Xcode for emulator

### Steps

1. **Clone and navigate to project:**
   ```bash
   cd HealthTrace-Flutter
   ```

2. **Get dependencies:**
   ```bash
   flutter pub get
   ```

3. **Build generated files (for code generation):**
   ```bash
   flutter pub run build_runner build
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

### Running on Specific Platform

```bash
# iOS
flutter run -d iPhone

# Android
flutter run -d android

# Web (if enabled)
flutter run -d chrome
```

---

## ✨ Features Implemented

### Authentication
- ✅ Login with email/password
- ✅ Sign up
- ✅ OTP verification
- ✅ Password reset
- ✅ Token refresh mechanism
- ✅ Session management

### Health Dashboard
- ✅ Health summary cards
- ✅ Abnormal parameters highlighting
- ✅ Recent reports view
- ✅ Quick action buttons
- ✅ Refresh functionality

### Reports Management
- ✅ Upload reports
- ✅ Extract health parameters
- ✅ Verify extracted data
- ✅ View report details
- ✅ Report list with filtering

### Trends & Analytics
- ✅ Parameter trend graphs
- ✅ Historical data analysis
- ✅ Trend summary
- ✅ Comparative insights

### Doctor Visit Flow
- ✅ Select doctor type
- ✅ Select visit purpose
- ✅ Parameter selection
- ✅ Auto-summary generation
- ✅ AI refinement (placeholder)

### User Profile
- ✅ Profile management
- ✅ Health profile setup
- ✅ Privacy settings
- ✅ Account deletion
- ✅ Logout functionality

---

## 🔄 State Management

We use **Riverpod** for state management with the following patterns:

### Provider Types

1. **Service Providers** (Dependency Injection)
   ```dart
   final authRepositoryProvider = Provider<AuthRepository>((ref) {
     return AuthRepositoryImpl(...);
   });
   ```

2. **State Providers** (Simple state)
   ```dart
   final counterProvider = StateProvider<int>((ref) => 0);
   ```

3. **State Notifier Providers** (Complex state)
   ```dart
   final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
     return AuthNotifier(...);
   });
   ```

4. **Future Providers** (Async data)
   ```dart
   final getUserProvider = FutureProvider<User>((ref) async {
     return await authRepository.getCurrentUser();
   });
   ```

### Example Usage in UI

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch providers
    final authState = ref.watch(authStateProvider);
    final user = ref.watch(getCurrentUserUseCaseProvider);

    // Access use cases to perform actions
    final loginUseCase = ref.read(loginUseCaseProvider);
    
    return Text('User: ${authState.user}');
  }
}
```

---

## 🔧 Extending the Project

### Adding a New Feature

#### 1. Create Domain Layer (Business Logic)

```dart
// domain/entities/new_entity.dart
class NewEntity {
  final String id;
  final String name;
  // ... fields
}

// domain/repositories/new_repository.dart
abstract class NewRepository {
  Future<NewEntity> getData();
  Future<void> saveData(NewEntity data);
}

// domain/usecases/new_usecases.dart
class GetNewDataUseCase {
  final NewRepository repository;
  
  Future<NewEntity> call() => repository.getData();
}
```

#### 2. Create Data Layer (Implementation)

```dart
// data/models/new_model.dart
class NewModel extends NewEntity {
  factory NewModel.fromJson(Map<String, dynamic> json) => NewModel(...);
  
  NewEntity toEntity() => NewEntity(...);
}

// data/datasources/new_datasource.dart
abstract class NewRemoteDataSource {
  Future<NewModel> fetchData();
}

class MockNewRemoteDataSource implements NewRemoteDataSource {
  // Mock implementation
}

// data/repositories/new_repository_impl.dart
class NewRepositoryImpl implements NewRepository {
  final NewRemoteDataSource remoteDataSource;
  
  // Implementation
}
```

#### 3. Create State Management (Providers)

```dart
// presentation/providers/new_providers.dart
final newRepositoryProvider = Provider<NewRepository>((ref) {
  return NewRepositoryImpl(...);
});

final newDataProvider = FutureProvider<NewEntity>((ref) async {
  final repository = ref.watch(newRepositoryProvider);
  return repository.getData();
});
```

#### 4. Create UI Layer (Screens/Widgets)

```dart
// presentation/screens/new_screen.dart
class NewScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newData = ref.watch(newDataProvider);
    
    return newData.when(
      data: (data) => _buildContent(data),
      loading: () => const AppLoadingIndicator(),
      error: (error, stack) => AppErrorWidget(message: error.toString()),
    );
  }
}
```

---

## 🔌 Backend Integration

### Step 1: Replace Mock Data Sources

```dart
// data/datasources/auth_datasource.dart

// Remove or keep MockAuthRemoteDataSource for development
// Create RealAuthRemoteDataSource with Retrofitterclient

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

@RestApi(baseUrl: 'https://api.healthtrace.com/v1')
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String baseUrl}) = _AuthApiClient;

  @POST('/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);

  @POST('/auth/signup')
  Future<AuthResponse> signup(@Body() SignupRequest request);
}

class RealAuthRemoteDataSource implements AuthRemoteDataSource {
  final AuthApiClient apiClient;
  
  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await apiClient.login(
      LoginRequest(email: email, password: password),
    );
    return response.toJson();
  }
}
```

### Step 2: Update Repository Configuration

```dart
// presentation/providers/auth_providers.dart

// Change this:
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return MockAuthRemoteDataSource();
});

// To this:
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = Dio();
  final apiClient = AuthApiClient(dio);
  return RealAuthRemoteDataSource(apiClient: apiClient);
});
```

### Step 3: Update API Constants

```dart
// core/constants/app_constants.dart

class ApiConstants {
  static const String baseUrl = 'https://your-real-api.com/v1';
  // ... rest of the constants
}
```

### Step 4: Handle Authentication Headers

```dart
// Create an Interceptor for Dio to attach auth tokens

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
  ));

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ),
  );

  return dio;
});
```

---

## 🧪 Testing

### Unit Tests

```dart
// test/domain/usecases/auth_usecases_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('LoginUseCase', () {
    late LoginUseCase loginUseCase;
    late MockAuthRepository mockAuthRepository;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      loginUseCase = LoginUseCase(repository: mockAuthRepository);
    });

    test('should return auth tokens when login succeeds', () async {
      when(mockAuthRepository.login(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => ('accessToken', 'refreshToken'));

      final result = await loginUseCase(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result, equals(('accessToken', 'refreshToken')));
      verify(mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).called(1);
    });
  });
}
```

###  Widget Tests

```dart
// test/presentation/screens/login_screen_test.dart

void main() {
  group('LoginScreen', () {
    testWidgets('displays login form', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: HealthTraceApp()),
      );

      expect(find.byType(AppTextField), findsWidgets);
      expect(find.byType(AppButton), findsWidgets);
    });
  });
}
```

---

## 📝 Best Practices

### 1. **Always Use Repositories**
- ❌ Don't call datasources directly from UI
- ✅ Always use repositories as abstraction layer

### 2. **Dependency Injection via Providers**
```dart
// ✅ Good
final repo = ref.watch(repositoryProvider);

// ❌ Avoid
final repo = AuthRepositoryImpl();
```

### 3. **Error Handling**
```dart
// ✅ Use try-catch with proper logging
try {
  await useCase();
} catch (e) {
  AppLogger.error('Operation failed', e);
  // Show user-friendly error
}
```

### 4. **Loading States**
Always show loading indicators:
```dart
ref.watch(dataProvider).when(
  data: (data) => _buildContent(data),
  loading: () => AppLoadingIndicator(),
  error: (err, _) => AppErrorWidget(message: err.toString()),
);
```

### 5. **Immutable Entities**
```dart
// ✅ Use copyWith for immutability
class User {
  User copyWith({String? name}) =>
    User(name: name ?? this.name);
}
```

### 6. **Model-to-Entity Conversion**
Always convert models to entities at repository layer:
```dart
// ✅ In repository
return userModel.toEntity();

// ❌ Don't expose models in domain
```

---

## 🗂️ File Naming Conventions

- **Screens**: `*_screen.dart`
- **Widgets**: `*_widget.dart`
- **Models**: `*_model.dart` or `*_models.dart`
- **Entities**: `*_entity.dart`
- **Repositories**: `*_repository.dart` (interface), `*_repository_impl.dart` (implementation)
- **Data Sources**: `*_datasource.dart`
- **Providers**: `*_providers.dart`

---

## 📱 Responsive Design

Use the provided extensions for responsive layouts:

```dart
// Check screen size
context.isMobile    // < 600
context.isTablet    // 600 - 1200
context.isDesktop   // >= 1200

// Build responsive widgets
SizedBox(
  width: context.screenWidth * 0.8,
  child: MyWidget(),
)
```

---

## 🔐 Security Considerations

1. **Token Storage**: Tokens are stored in mock local storage (use secure storage in production)
2. **API Calls**: Always use HTTPS
3. **Data Validation**: Validate all user inputs
4. **Error Messages**: Don't expose sensitive information in errors

### Add Secure Storage:
```bash
flutter pub add flutter_secure_storage
```

```dart
final secureStorage = FlutterSecureStorage();
await secureStorage.write(key: 'token', value: accessToken);
```

---

## 📦 Dependencies

Key packages used:

- **flutter_riverpod**: State management
- **go_router**: Navigation
- **dio**: HTTP client
- **retrofit**: API client generator
- **json_serializable**: JSON serialization
- **freezed**: Code generation for immutable models
- **logger**: Logging utility

---

## 🤝 Contributing

When adding new features:

1. Follow the Clean Architecture structure
2. Write unit tests for business logic
3. Use consistent naming conventions
4. Update this README with new features
5. Keep components modular and reusable

---

## 📄 License

This project is open source and available under the MIT License.

---

## 🆘 Troubleshooting

### Build Runner Issues
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### Router Not Working
- Ensure `goRouterProvider` is properly initialized
- Check route paths match exactly
- Verify auth state is being watched

### State Not Updating
- Verify you're using `watch()` not `read()`
- Check provider dependencies are correct
- Ensure state notifiers call `state =` to update

---

**Happy Coding! 🚀**
