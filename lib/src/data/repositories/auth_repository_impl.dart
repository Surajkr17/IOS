import 'package:health_trace/src/data/datasources/auth_datasource.dart';
import 'package:health_trace/src/data/models/user_models.dart';
import 'package:health_trace/src/domain/entities/user.dart';
import 'package:health_trace/src/domain/repositories/auth_repository.dart';
import 'package:health_trace/src/core/utils/logger.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<(String, String)> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
      );

      final accessToken = response['accessToken'] as String;
      final refreshToken = response['refreshToken'] as String;
      final userJson = response['user'] as Map<String, dynamic>;

      final user = UserModel.fromJson(userJson);

      // Save tokens and user locally
      await localDataSource.saveAccessToken(accessToken);
      await localDataSource.saveRefreshToken(refreshToken);
      await localDataSource.saveUser(user);

      AppLogger.info('Login successful for ${user.email}');

      return (accessToken, refreshToken);
    } catch (e) {
      AppLogger.error('Login failed', e);
      rethrow;
    }
  }

  @override
  Future<(String, String)> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await remoteDataSource.signup(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      final accessToken = response['accessToken'] as String;
      final refreshToken = response['refreshToken'] as String;
      final userJson = response['user'] as Map<String, dynamic>;

      final user = UserModel.fromJson(userJson);

      await localDataSource.saveAccessToken(accessToken);
      await localDataSource.saveRefreshToken(refreshToken);
      await localDataSource.saveUser(user);

      AppLogger.info('Signup successful for $email');

      return (accessToken, refreshToken);
    } catch (e) {
      AppLogger.error('Signup failed', e);
      rethrow;
    }
  }

  @override
  Future<void> sendOtp({required String email}) async {
    try {
      await remoteDataSource.sendOtp(email: email);
      AppLogger.info('OTP sent to $email');
    } catch (e) {
      AppLogger.error('Send OTP failed', e);
      rethrow;
    }
  }

  @override
  Future<(String, String)> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await remoteDataSource.verifyOtp(
        email: email,
        otp: otp,
      );

      final accessToken = response['accessToken'] as String;
      final refreshToken = response['refreshToken'] as String;
      final userJson = response['user'] as Map<String, dynamic>;

      final user = UserModel.fromJson(userJson);

      await localDataSource.saveAccessToken(accessToken);
      await localDataSource.saveRefreshToken(refreshToken);
      await localDataSource.saveUser(user);

      AppLogger.info('OTP verified for $email');

      return (accessToken, refreshToken);
    } catch (e) {
      AppLogger.error('OTP verification failed', e);
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    try {
      await remoteDataSource.forgotPassword(email: email);
      AppLogger.info('Password reset request sent to $email');
    } catch (e) {
      AppLogger.error('Forgot password failed', e);
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(
        token: token,
        newPassword: newPassword,
      );
      AppLogger.info('Password reset successful');
    } catch (e) {
      AppLogger.error('Password reset failed', e);
      rethrow;
    }
  }

  @override
  Future<String> refreshAccessToken({required String refreshToken}) async {
    try {
      final newAccessToken = await remoteDataSource.refreshAccessToken(
        refreshToken: refreshToken,
      );
      await localDataSource.saveAccessToken(newAccessToken);
      AppLogger.info('Access token refreshed');
      return newAccessToken;
    } catch (e) {
      AppLogger.error('Token refresh failed', e);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearAll();
      AppLogger.info('Logout successful');
    } catch (e) {
      AppLogger.error('Logout failed', e);
      rethrow;
    }
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      final user = await localDataSource.getUser();
      if (user == null) {
        throw Exception('No user found');
      }
      return user.toEntity();
    } catch (e) {
      AppLogger.error('Get current user failed', e);
      rethrow;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final token = await localDataSource.getAccessToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      AppLogger.error('Check authentication failed', e);
      return false;
    }
  }
}
