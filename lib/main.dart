import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/auth/firebase_login_screen.dart';
import 'features/home/main_navigation.dart';
import 'data/services/stats_service.dart';
import 'data/services/firebase_auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Hive for local storage
  await Hive.initFlutter();
  
  // Initialize stats service
  await StatsService.init();
  
  runApp(
    const ProviderScope(
      child: UreshiiPartnerApp(),
    ),
  );
}

class UreshiiPartnerApp extends StatelessWidget {
  const UreshiiPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URESHII Partner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const FirebaseLoginScreen(),
        '/home': (context) => const MainNavigation(),
      },
    );
  }
}

/// Authentication Wrapper
/// Checks Firebase auth state and shows appropriate screen
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = FirebaseAuthService();
    
    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show splash screen while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        
        // User is logged in
        if (snapshot.hasData && snapshot.data != null) {
          return const MainNavigation();
        }
        
        // User is not logged in
        return const FirebaseLoginScreen();
      },
    );
  }
}
