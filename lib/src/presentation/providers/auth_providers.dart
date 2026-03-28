import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_trace/src/data/datasources/auth_datasource.dart';
import 'package:health_trace/src/data/repositories/auth_repository_impl.dart';
import 'package:health_trace/src/domain/repositories/auth_repository.dart';
import 'package:health_trace/src/domain/usecases/auth_usecases.dart';

// ============== Data Sources ==============

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return MockAuthRemoteDataSource();
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return MockAuthLocalDataSource();
});

// ============== Repositories ==============

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);

  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// ============== Use Cases ==============

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository: authRepository);
});

final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SignupUseCase(repository: authRepository);
});

final sendOtpUseCaseProvider = Provider<SendOtpUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SendOtpUseCase(repository: authRepository);
});

final verifyOtpUseCaseProvider = Provider<VerifyOtpUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return VerifyOtpUseCase(repository: authRepository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository: authRepository);
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository: authRepository);
});

final isAuthenticatedUseCaseProvider = Provider<IsAuthenticatedUseCase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return IsAuthenticatedUseCase(repository: authRepository);
});

// ============== State Providers ==============

// State class for auth state
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;
  final dynamic user;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
    dynamic user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error ?? this.error,
      user: user ?? this.user,
    );
  }
}

// Auth state notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final IsAuthenticatedUseCase isAuthenticatedUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthNotifier({
    required this.isAuthenticatedUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthState());

  Future<void> checkAuthentication() async {
    try {
      final isAuth = await isAuthenticatedUseCase();
      if (isAuth) {
        final user = await getCurrentUserUseCase();
        state = state.copyWith(
          isAuthenticated: true,
          user: user,
        );
      } else {
        state = state.copyWith(isAuthenticated: false);
      }
    } catch (e) {
      state = state.copyWith(
        isAuthenticated: false,
        error: e.toString(),
      );
    }
  }

  void setLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }

  void setAuthenticated(bool isAuthenticated) {
    state = state.copyWith(isAuthenticated: isAuthenticated);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final isAuthenticatedUseCase = ref.watch(isAuthenticatedUseCaseProvider);
  final getCurrentUserUseCase = ref.watch(getCurrentUserUseCaseProvider);

  return AuthNotifier(
    isAuthenticatedUseCase: isAuthenticatedUseCase,
    getCurrentUserUseCase: getCurrentUserUseCase,
  );
});

// Login state manager
final loginProvider = FutureProvider.family<String, Map<String, String>>((ref, params) async {
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final (accessToken, refreshToken) = await loginUseCase(
    email: params['email']!,
    password: params['password']!,
  );
  
  // Update auth state
  ref.read(authStateProvider.notifier).checkAuthentication();
  
  return accessToken;
});

// Signup state manager
final signupProvider = FutureProvider.family<String, Map<String, String>>((ref, params) async {
  final signupUseCase = ref.watch(signupUseCaseProvider);
  final (accessToken, refreshToken) = await signupUseCase(
    email: params['email']!,
    password: params['password']!,
    firstName: params['firstName']!,
    lastName: params['lastName']!,
  );
  
  // Update auth state
  ref.read(authStateProvider.notifier).checkAuthentication();
  
  return accessToken;
});

// OTP state manager
final otpProvider = FutureProvider.family<void, String>((ref, email) async {
  final sendOtpUseCase = ref.watch(sendOtpUseCaseProvider);
  await sendOtpUseCase(email: email);
});

// Verify OTP state manager
final verifyOtpProvider = FutureProvider.family<String, Map<String, String>>((ref, params) async {
  final verifyOtpUseCase = ref.watch(verifyOtpUseCaseProvider);
  final (accessToken, refreshToken) = await verifyOtpUseCase(
    email: params['email']!,
    otp: params['otp']!,
  );
  
  // Update auth state
  ref.read(authStateProvider.notifier).checkAuthentication();
  
  return accessToken;
});

// Logout state manager
final logoutProvider = FutureProvider<void>((ref) async {
  final logoutUseCase = ref.watch(logoutUseCaseProvider);
  await logoutUseCase();
  
  // Update auth state
  ref.read(authStateProvider.notifier).state = AuthState();
});
