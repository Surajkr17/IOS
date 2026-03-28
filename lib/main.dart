import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_trace/src/core/theme/app_theme.dart';
import 'package:health_trace/src/core/constants/app_strings.dart';
import 'package:health_trace/src/presentation/routes/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize any services here
  // Example: hive, shared_preferences, etc.

  runApp(const ProviderScope(child: HealthTraceApp()));
}

class HealthTraceApp extends ConsumerWidget {
  const HealthTraceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the router provider
    final goRouter = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: AppStrings.appName,
      routerConfig: goRouter,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      // Customize error handling
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(1.0), // Prevent system text scaling
          ),
          child: child!,
        );
      },
    );
  }
}
