import 'package:health_trace/src/data/models/user_models.dart';
import 'package:uuid/uuid.dart';

/// Mock data source for authentication
/// In production, this would be replaced with actual API calls via Dio/Retrofit
abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  Future<void> sendOtp({required String email});

  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  });

  Future<void> forgotPassword({required String email});

  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  Future<String> refreshAccessToken({required String refreshToken});

  Future<void> logout();

  Future<UserModel> getCurrentUser({required String userId});
}

class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  // Mock user database
  static final Map<String, UserModel> _users = {
    'user1': UserModel(
      id: 'user1',
      email: 'john@example.com',
      firstName: 'John',
      lastName: 'Doe',
      phoneNumber: '9876543210',
      profileImage: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  };

  static final Map<String, String> _otpMap = {};
  static final Map<String, String> _tokens = {};

  @override
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // Check if user exists (mock validation)
    final user = _users.values.firstWhere(
      (u) => u.email == email,
      orElse: () => throw Exception('Invalid email or password'),
    );

    // Generate tokens
    final accessToken = 'access_${const Uuid().v4()}';
    final refreshToken = 'refresh_${const Uuid().v4()}';

    _tokens[user.id] = accessToken;

    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }

  @override
  Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Check if user already exists
    if (_users.values.any((u) => u.email == email)) {
      throw Exception('Email already registered');
    }

    // Create new user
    final userId = const Uuid().v4();
    final user = UserModel(
      id: userId,
      email: email,
      firstName: firstName,
      lastName: lastName,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _users[userId] = user;

    // Generate tokens
    final accessToken = 'access_${const Uuid().v4()}';
    final refreshToken = 'refresh_${const Uuid().v4()}';
    _tokens[userId] = accessToken;

    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }

  @override
  Future<void> sendOtp({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Generate random OTP
    final otp = List.generate(6, (_) => (0 + 9).toRadixString(10)).join();
    _otpMap[email] = otp;

    // In production, send OTP via email
    print('OTP for $email: $otp');
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final storedOtp = _otpMap[email];
    if (storedOtp == null || storedOtp != otp) {
      throw Exception('Invalid OTP');
    }

    // Find or create user
    final user = _users.values.firstWhere(
      (u) => u.email == email,
      orElse: () {
        final newUser = UserModel(
          id: const Uuid().v4(),
          email: email,
          firstName: 'User',
          lastName: 'Name',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        _users[newUser.id] = newUser;
        return newUser;
      },
    );

    // Generate tokens
    final accessToken = 'access_${const Uuid().v4()}';
    final refreshToken = 'refresh_${const Uuid().v4()}';
    _tokens[user.id] = accessToken;

    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // Check if user exists
    if (!_users.values.any((u) => u.email == email)) {
      throw Exception('User not found');
    }

    // In production, send reset link via email
    print('Password reset link sent to $email');
  }

  @override
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // In production, verify token and update password
  }

  @override
  Future<String> refreshAccessToken({required String refreshToken}) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return 'access_${const Uuid().v4()}';
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _tokens.clear();
  }

  @override
  Future<UserModel> getCurrentUser({required String userId}) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final user = _users[userId];
    if (user == null) {
      throw Exception('User not found');
    }

    return user;
  }
}

/// Local storage data source for caching
abstract class AuthLocalDataSource {
  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();
  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearAll();
}

class MockAuthLocalDataSource implements AuthLocalDataSource {
  static final Map<String, dynamic> _localStorage = {};

  @override
  Future<void> saveAccessToken(String token) async {
    _localStorage['access_token'] = token;
  }

  @override
  Future<String?> getAccessToken() async {
    return _localStorage['access_token'] as String?;
  }

  @override
  Future<void> saveRefreshToken(String token) async {
    _localStorage['refresh_token'] = token;
  }

  @override
  Future<String?> getRefreshToken() async {
    return _localStorage['refresh_token'] as String?;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    _localStorage['user'] = user;
  }

  @override
  Future<UserModel?> getUser() async {
    return _localStorage['user'] as UserModel?;
  }

  @override
  Future<void> clearAll() async {
    _localStorage.clear();
  }
}
