import 'package:health_trace/src/domain/entities/user.dart';

abstract class AuthRepository {
  // Login with email and password
  Future<(String accessToken, String refreshToken)> login({
    required String email,
    required String password,
  });

  // Register new user
  Future<(String accessToken, String refreshToken)> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  // Send OTP to email
  Future<void> sendOtp({required String email});

  // Verify OTP
  Future<(String accessToken, String refreshToken)> verifyOtp({
    required String email,
    required String otp,
  });

  // Forgot password - send reset link
  Future<void> forgotPassword({required String email});

  // Reset password with token
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  // Refresh access token
  Future<String> refreshAccessToken({required String refreshToken});

  // Logout
  Future<void> logout();

  // Get current user
  Future<User> getCurrentUser();

  // Check if user is authenticated
  Future<bool> isAuthenticated();
}

abstract class UserRepository {
  // Get user profile
  Future<User> getUserProfile({String? userId});

  // Update user profile
  Future<User> updateUserProfile({
    required String userId,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  });

  // Upload profile image
  Future<String> uploadProfileImage({
    required String userId,
    required String imagePath,
  });

  // Delete account
  Future<void> deleteAccount({required String userId});

  // Upload health profile
  Future<HealthProfile> uploadHealthProfile({
    required String userId,
    required HealthProfile healthProfile,
  });

  // Get health profile
  Future<HealthProfile?> getHealthProfile({String? userId});

  // Update health profile
  Future<HealthProfile> updateHealthProfile({
    required String userId,
    required HealthProfile healthProfile,
  });
}

class HealthProfile {
  final String userId;
  final int age;
  final String sex;
  final double height;
  final double weight;
  final String? bloodType;
  final List<String> medicalConditions;
  final List<dynamic> medications; // List<Medication>
  final List<String> allergies;
  final dynamic lifestyle; // LifestyleData?
  final DateTime? lastUpdated;

  HealthProfile({
    required this.userId,
    required this.age,
    required this.sex,
    required this.height,
    required this.weight,
    this.bloodType,
    required this.medicalConditions,
    required this.medications,
    required this.allergies,
    this.lifestyle,
    this.lastUpdated,
  });
}
