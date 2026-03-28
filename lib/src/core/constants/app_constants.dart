class ApiConstants {
  // API Base Configuration
  static const String baseUrl = 'https://api.healthtrace.com/v1';
  static const String apiVersion = 'v1';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 10);

  // Authentication Endpoints
  static const String loginEndpoint = '/auth/login';
  static const String signupEndpoint = '/auth/signup';
  static const String verifyOtpEndpoint = '/auth/verify-otp';
  static const String forgotPasswordEndpoint = '/auth/forgot-password';
  static const String resetPasswordEndpoint = '/auth/reset-password';
  static const String refreshTokenEndpoint = '/auth/refresh-token';

  // User Endpoints
  static const String getUserEndpoint = '/users/me';
  static const String updateUserEndpoint = '/users/me';
  static const String deleteAccountEndpoint = '/users/me';
  static const String uploadHealthProfileEndpoint = '/users/health-profile';

  // Report Endpoints
  static const String uploadReportEndpoint = '/reports/upload';
  static const String getReportsEndpoint = '/reports';
  static const String getReportDetailEndpoint = '/reports/{id}';
  static const String deleteReportEndpoint = '/reports/{id}';
  static const String extractReportDataEndpoint = '/reports/{id}/extract';

  // Trends Endpoints
  static const String getTrendsEndpoint = '/trends';
  static const String getTrendDetailEndpoint = '/trends/{parameter}';

  // Doctor Visit Endpoints
  static const String submitDoctorVisitEndpoint = '/doctor-visits';
  static const String generateSummaryEndpoint = '/doctor-visits/generate-summary';
  static const String refineSummaryEndpoint = '/doctor-visits/refine-summary';

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10 MB
  static const List<String> allowedFileTypes = ['pdf', 'jpg', 'jpeg', 'png'];
}

class ValidationConstants {
  static const int minPasswordLength = 8;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int phoneNumberLength = 10;
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\d{10}$';
}

class StorageKeys {
  // Authentication
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String isLoggedIn = 'is_logged_in';
  static const String lastLoginTime = 'last_login_time';

  // User Data
  static const String userProfile = 'user_profile';
  static const String healthProfile = 'health_profile';

  // App Preferences
  static const String isDarkMode = 'is_dark_mode';
  static const String appLanguage = 'app_language';
  static const String isFirstLaunch = 'is_first_launch';
  static const String onboardingCompleted = 'onboarding_completed';

  // Cache
  static const String reportsCache = 'reports_cache';
  static const String trendsCache = 'trends_cache';
  static const String reportsCacheTimestamp = 'reports_cache_timestamp';
}

class RouteConstants {
  // Root Routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';
  static const String healthProfileSetup = '/health-profile-setup';
  
  // Main App Routes
  static const String home = '/home';
  static const String reports = '/reports';
  static const String uploadReport = '/reports/upload';
  static const String reportDetail = '/reports/:id';
  static const String verifyExtraction = '/reports/:id/verify';
  
  static const String trends = '/trends';
  static const String trendDetail = '/trends/:parameter';
  
  static const String doctorVisit = '/doctor-visit';
  static const String doctorVisitStep1 = '/doctor-visit/step1';
  static const String doctorVisitStep2 = '/doctor-visit/step2';
  static const String doctorVisitSummary = '/doctor-visit/summary';
  
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String privacySettings = '/profile/privacy';
  static const String termsAndPrivacy = '/profile/terms-privacy';
}

class CacheConstants {
  static const int reportsCacheDuration = 1; // 1 hour
  static const int trendsCacheDuration = 1; // 1 hour
  static const int userCacheDuration = 24; // 24 hours
}
