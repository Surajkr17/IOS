import 'package:health_trace/src/core/constants/app_constants.dart';
import 'package:health_trace/src/core/constants/app_strings.dart';

class ValidationUtil {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    final emailRegex = RegExp(ValidationConstants.emailRegex);
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    if (value.length < ValidationConstants.minPasswordLength) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    if (value != password) {
      return AppStrings.passwordMismatch;
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    final phoneRegex = RegExp(ValidationConstants.phoneRegex);
    final digits = value.replaceAll(RegExp(r'[^\d]'), '');
    if (!phoneRegex.hasMatch(digits)) {
      return AppStrings.invalidPhone;
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    if (value.length < ValidationConstants.minNameLength) {
      return 'Name must be at least ${ValidationConstants.minNameLength} characters';
    }
    if (value.length > ValidationConstants.maxNameLength) {
      return 'Name must not exceed ${ValidationConstants.maxNameLength} characters';
    }
    return null;
  }

  static String? validateRequiredField(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    return null;
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    if (value.length != 6 || !value.contains(RegExp(r'^\d{6}$'))) {
      return AppStrings.invalidOtp;
    }
    return null;
  }

  static String? validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    final height = double.tryParse(value);
    if (height == null || height <= 0 || height > 300) {
      return 'Please enter a valid height';
    }
    return null;
  }

  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    final weight = double.tryParse(value);
    if (weight == null || weight <= 0 || weight > 500) {
      return 'Please enter a valid weight';
    }
    return null;
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.requiredField;
    }
    final age = int.tryParse(value);
    if (age == null || age < 1 || age > 150) {
      return 'Please enter a valid age';
    }
    return null;
  }
}
