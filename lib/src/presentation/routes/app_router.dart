import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_trace/src/presentation/providers/auth_providers.dart';
import 'package:health_trace/src/core/constants/app_constants.dart';
import 'package:health_trace/src/presentation/screens/login_screen.dart';
import 'package:health_trace/src/presentation/screens/forgot_password_screen.dart';
import 'package:health_trace/src/presentation/screens/home_screen.dart';
import 'package:health_trace/src/presentation/screens/onboarding_screen.dart';
import 'package:health_trace/src/presentation/screens/reports_screen.dart';
import 'package:health_trace/src/presentation/screens/report_detail_screen.dart';
import 'package:health_trace/src/presentation/screens/extraction_verification_screen.dart';
import 'package:health_trace/src/presentation/screens/trends_screen.dart';
import 'package:health_trace/src/presentation/screens/doctor_visit_screen.dart';
import 'package:health_trace/src/presentation/screens/profile_screen.dart';
import 'package:health_trace/src/presentation/screens/splash_screen.dart';

// Placeholder screen for now
class PlaceholderScreen extends StatelessWidget {
  final String name;

  const PlaceholderScreen({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Text('$name Screen - To be implemented'),
      ),
    );
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      // Check if user is authenticated
      final isAuth = authState.isAuthenticated;
      final isGoingToAuth = state.matchedLocation.startsWith('/auth') ||
          state.matchedLocation == RouteConstants.splash ||
          state.matchedLocation == RouteConstants.onboarding;

      if (!isAuth && !isGoingToAuth) {
        return RouteConstants.login;
      }

      if (isAuth && isGoingToAuth) {
        return RouteConstants.home;
      }

      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: '/',
        name: 'splash',
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: SplashScreen(),
          );
        },
      ),

      // Onboarding
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: OnboardingScreen(),
          );
        },
      ),

      // Auth Routes
      GoRoute(
        path: '/auth',
        name: 'auth',
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: PlaceholderScreen(name: 'Auth'),
          );
        },
        routes: [
          GoRoute(
            path: 'login',
            name: 'login',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: LoginScreen(isSignup: false),
              );
            },
          ),
          GoRoute(
            path: 'signup',
            name: 'signup',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: LoginScreen(isSignup: true),
              );
            },
          ),
          GoRoute(
            path: 'forgot-password',
            name: 'forgotPassword',
            pageBuilder: (context, state) {
              return const MaterialPage(
                child: ForgotPasswordScreen(),
              );
            },
          ),
          GoRoute(
            path: 'verify-otp',
            name: 'verifyOtp',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: PlaceholderScreen(name: 'Verify OTP'),
              );
            },
          ),
        ],
      ),

      // Health Profile Setup
      GoRoute(
        path: '/health-profile-setup',
        name: 'healthProfileSetup',
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: PlaceholderScreen(name: 'Health Profile Setup'),
          );
        },
      ),

      // Main App Routes (after auth)
      GoRoute(
        path: '/home',
        name: 'home',
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: HomeScreen(),
          );
        },
      ),

      GoRoute(
        path: '/reports',
        name: 'reports',
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: ReportsScreen(),
          );
        },
        routes: [
          GoRoute(
            path: ':id',
            name: 'reportDetail',
            pageBuilder: (context, state) {
              final reportId = state.pathParameters['id'];
              return NoTransitionPage(
                child: ReportDetailScreen(reportId: reportId),
              );
            },
            routes: [
              GoRoute(
                path: 'verify',
                name: 'verifyExtraction',
                pageBuilder: (context, state) {
                  final reportId = state.pathParameters['id'];
                  return NoTransitionPage(
                    child: ExtractionVerificationScreen(reportId: reportId),
                  );
                },
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: '/trends',
        name: 'trends',
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: TrendsScreen(),
          );
        },
        routes: [
          GoRoute(
            path: ':parameter',
            name: 'trendDetail',
            pageBuilder: (context, state) {
              final parameter = state.pathParameters['parameter'];
              return NoTransitionPage(
                child: PlaceholderScreen(name: 'Trend Detail - $parameter'),
              );
            },
          ),
        ],
      ),

      GoRoute(
        path: '/doctor-visit',
        name: 'doctorVisit',
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: DoctorVisitScreen(),
          );
        },
        routes: [
          GoRoute(
            path: 'step1',
            name: 'doctorVisitStep1',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: PlaceholderScreen(name: 'Doctor Visit Step 1'),
              );
            },
          ),
          GoRoute(
            path: 'step2',
            name: 'doctorVisitStep2',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: PlaceholderScreen(name: 'Doctor Visit Step 2'),
              );
            },
          ),
          GoRoute(
            path: 'summary',
            name: 'doctorVisitSummary',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: PlaceholderScreen(name: 'Doctor Visit Summary'),
              );
            },
          ),
        ],
      ),

      GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: ProfileScreen(),
          );
        },
        routes: [
          GoRoute(
            path: 'edit',
            name: 'profileEdit',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: PlaceholderScreen(name: 'Edit Profile'),
              );
            },
          ),
          GoRoute(
            path: 'privacy',
            name: 'privacySettings',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: PlaceholderScreen(name: 'Privacy Settings'),
              );
            },
          ),
          GoRoute(
            path: 'terms-privacy',
            name: 'termsAndPrivacy',
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: PlaceholderScreen(name: 'Terms & Privacy'),
              );
            },
          ),
        ],
      ),
    ],
  );
});
