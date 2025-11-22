import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/splash_screen.dart';
import 'features/home/main_navigation.dart';
import 'data/services/stats_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const MainNavigation(),
      },
    );
  }
}
