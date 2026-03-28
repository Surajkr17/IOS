import 'package:health_trace/src/domain/repositories/auth_repository.dart';
import 'package:health_trace/src/domain/entities/user.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<(String accessToken, String refreshToken)> call({
    required String email,
    required String password,
  }) async {
    return repository.login(email: email, password: password);
  }
}

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase({required this.repository});

  Future<(String accessToken, String refreshToken)> call({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    return repository.signup(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }
}

class SendOtpUseCase {
  final AuthRepository repository;

  SendOtpUseCase({required this.repository});

  Future<void> call({required String email}) async {
    return repository.sendOtp(email: email);
  }
}

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase({required this.repository});

  Future<(String accessToken, String refreshToken)> call({
    required String email,
    required String otp,
  }) async {
    return repository.verifyOtp(email: email, otp: otp);
  }
}

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<void> call() async {
    return repository.logout();
  }
}

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase({required this.repository});

  Future<User> call() async {
    return repository.getCurrentUser();
  }
}

class IsAuthenticatedUseCase {
  final AuthRepository repository;

  IsAuthenticatedUseCase({required this.repository});

  Future<bool> call() async {
    return repository.isAuthenticated();
  }
}
