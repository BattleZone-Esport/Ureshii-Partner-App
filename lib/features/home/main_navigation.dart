import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../core/constants/colors.dart';
import '../../core/theme/text_styles.dart';
import 'home_screen.dart';
import '../characters/characters_screen.dart';
import '../projects/projects_screen.dart';
import '../profile/profile_screen.dart';
import '../chat/chat_screen.dart';

/// Main Navigation Wrapper
/// Handles bottom navigation and screen switching
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  
  // List of screens for bottom navigation
  final List<Widget> _screens = const [
    HomeScreen(),
    CharactersScreen(),
    ProjectsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openNewChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      
      // Glassmorphic Bottom Navigation Bar
      bottomNavigationBar: GlassmorphicContainer(
        width: double.infinity,
        height: 80,
        borderRadius: 0,
        blur: 20,
        alignment: Alignment.center,
        border: 0,
        linearGradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.surfaceColor.withValues(alpha: 0.5),
            AppColors.surfaceColor.withValues(alpha: 0.3),
          ],
        ),
        borderGradient: const LinearGradient(
          colors: [Colors.transparent, Colors.transparent],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'Home', 0),
              _buildNavItem(Icons.auto_awesome, 'Characters', 1),
              _buildNavItem(Icons.folder_copy, 'Projects', 2),
              _buildNavItem(Icons.person, 'Profile', 3),
            ],
          ),
        ),
      ),
      
      // Floating Action Button for New Chat
      floatingActionButton: _selectedIndex == 0 || _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: _openNewChat,
              icon: const Icon(Icons.add),
              label: const Text('New Chat'),
              backgroundColor: AppColors.primaryPurple,
            )
                .animate()
                .scale(
                  delay: const Duration(milliseconds: 600),
                  duration: const Duration(milliseconds: 400),
                )
                .fadeIn()
          : null,
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? AppColors.primaryPurple.withValues(alpha: 0.2)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                icon,
                color: isSelected ? AppColors.primaryPurple : AppColors.textHint,
                size: isSelected ? 30 : 28,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.primaryPurple : AppColors.textHint,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: isSelected ? 12 : 11,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    ).animate(target: isSelected ? 1 : 0).scale(
          duration: const Duration(milliseconds: 300),
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
        );
  }
}
