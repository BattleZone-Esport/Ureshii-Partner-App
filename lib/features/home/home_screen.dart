import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/strings.dart';
import '../../core/theme/text_styles.dart';
import '../characters/characters_screen.dart';
import '../projects/projects_screen.dart';
import '../coding/ai_coding_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back! 👋',
                        style: AppTextStyles.headline2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ready to code with AI?',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.primaryPurple,
                    child: const Icon(
                      Icons.person,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideX(begin: -0.2, end: 0),
          ),

          // Quick Access Cards
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.quickAccess,
                    style: AppTextStyles.headline2,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Feature Cards Grid
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildListDelegate([
                _buildFeatureCard(
                  context: context,
                  icon: Icons.code,
                  title: 'AI Coding',
                  subtitle: 'Assistant',
                  gradient: AppColors.primaryGradient,
                  index: 0,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AICodingScreen(),
                      ),
                    );
                  },
                ),
                _buildFeatureCard(
                  context: context,
                  icon: Icons.auto_awesome,
                  title: 'Characters',
                  subtitle: '35+ Anime',
                  gradient: AppColors.accentGradient,
                  index: 1,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CharactersScreen(),
                      ),
                    );
                  },
                ),
                _buildFeatureCard(
                  context: context,
                  icon: Icons.folder_copy,
                  title: 'Projects',
                  subtitle: 'Manage',
                  gradient: const LinearGradient(
                    colors: [AppColors.accentGreen, AppColors.accentBlue],
                  ),
                  index: 2,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProjectsScreen(),
                      ),
                    );
                  },
                ),
                _buildFeatureCard(
                  context: context,
                  icon: Icons.chat_bubble,
                  title: 'Recent',
                  subtitle: 'Chats',
                  gradient: const LinearGradient(
                    colors: [AppColors.secondaryPink, AppColors.accentPink],
                  ),
                  index: 3,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Recent chats feature coming soon!'),
                        backgroundColor: AppColors.primaryPurple,
                      ),
                    );
                  },
                ),
              ]),
            ),
          ),

          // Recent Activity Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    AppStrings.recentChats,
                    style: AppTextStyles.headline2,
                  ),
                  const SizedBox(height: 16),
                  _buildEmptyState(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required int index,
    required VoidCallback onTap,
  }) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: double.infinity,
      borderRadius: 20,
      blur: 15,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.cardColor.withValues(alpha: 0.5),
          AppColors.surfaceColor.withValues(alpha: 0.3),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primaryPurple.withValues(alpha: 0.3),
          AppColors.secondaryPink.withValues(alpha: 0.3),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.textPrimary,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: 200 + (index * 100)),
        )
        .scale(
          delay: Duration(milliseconds: 200 + (index * 100)),
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: AppColors.textHint.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No recent chats',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Start a new conversation to get started!',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 400));
  }
}
