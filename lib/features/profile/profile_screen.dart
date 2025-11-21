import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../core/constants/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../data/models/user_stats_model.dart';
import '../../data/services/stats_service.dart';
import '../../data/services/firebase_auth_service.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserStatsModel _stats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    setState(() {
      _stats = StatsService.getStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Epic Profile Header
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryPurple.withValues(alpha: 0.3),
                      AppColors.secondaryPink.withValues(alpha: 0.3),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Animated particles
                    ...List.generate(15, (index) => Positioned(
                      left: (index * 60.0) % 400,
                      top: (index * 40.0) % 300,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.primaryPurple.withValues(alpha: 0.4),
                          shape: BoxShape.circle,
                        ),
                      )
                          .animate(onPlay: (controller) => controller.repeat(reverse: true))
                          .fadeIn(duration: Duration(milliseconds: 1000 + (index * 100)))
                          .scale(duration: Duration(milliseconds: 1500 + (index * 50))),
                    )),

                    // Profile Content
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Avatar with level indicator
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Glow effect
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppColors.primaryGradient,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryPurple.withValues(alpha: 0.5),
                                      blurRadius: 30,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                              // Avatar
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppColors.primaryGradient,
                                  border: Border.all(
                                    color: AppColors.textPrimary,
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              // Level badge
                              Positioned(
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.accentGradient,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.textPrimary,
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    'LV ${_stats.level}',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                              .animate()
                              .scale(duration: const Duration(milliseconds: 600))
                              .fadeIn(),

                          const SizedBox(height: 20),

                          // Username
                          Text(
                            'URESHII Dev',
                            style: AppTextStyles.headline1,
                          )
                              .animate()
                              .fadeIn(delay: const Duration(milliseconds: 200))
                              .slideY(begin: 0.3, end: 0),

                          const SizedBox(height: 8),

                          // Rank title
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _stats.rankTitle,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primaryPurple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(delay: const Duration(milliseconds: 400))
                              .scale(delay: const Duration(milliseconds: 400)),

                          const SizedBox(height: 16),

                          // Member since
                          Text(
                            'Member since ${DateFormat('MMM yyyy').format(_stats.memberSince)}',
                            style: AppTextStyles.bodySmall,
                          )
                              .animate()
                              .fadeIn(delay: const Duration(milliseconds: 600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Level Progress
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Level ${_stats.level}',
                          style: AppTextStyles.bodyMedium,
                        ),
                        Text(
                          'Level ${_stats.level + 1}',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _stats.levelProgress,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 800))
                        .slideX(begin: -0.5, end: 0),
                    const SizedBox(height: 8),
                    Text(
                      '${(_stats.levelProgress * 100).toInt()}% to next level',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
            ),

            // Stats Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                delegate: SliverChildListDelegate([
                  _buildStatCard(
                    icon: Icons.chat_bubble,
                    title: 'Messages',
                    value: '${_stats.totalMessages}',
                    gradient: AppColors.primaryGradient,
                    index: 0,
                  ),
                  _buildStatCard(
                    icon: Icons.chat,
                    title: 'Chats',
                    value: '${_stats.totalChats}',
                    gradient: AppColors.accentGradient,
                    index: 1,
                  ),
                  _buildStatCard(
                    icon: Icons.code,
                    title: 'Code Snippets',
                    value: '${_stats.codeSnippetsGenerated}',
                    gradient: const LinearGradient(
                      colors: [AppColors.accentGreen, AppColors.accentBlue],
                    ),
                    index: 2,
                  ),
                  _buildStatCard(
                    icon: Icons.auto_awesome,
                    title: 'Characters',
                    value: '${_stats.charactersUnlocked}',
                    gradient: const LinearGradient(
                      colors: [AppColors.secondaryPink, AppColors.accentPink],
                    ),
                    index: 3,
                  ),
                ]),
              ),
            ),

            // Achievements Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Achievements',
                      style: AppTextStyles.headline2,
                    )
                        .animate()
                        .fadeIn(delay: const Duration(milliseconds: 1000))
                        .slideX(begin: -0.2, end: 0),
                    const SizedBox(height: 16),
                    _buildAchievementsGrid(),
                  ],
                ),
              ),
            ),

            // Favorite Character
            if (_stats.favoriteCharacter != 'None')
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Favorite Character',
                        style: AppTextStyles.headline2,
                      ),
                      const SizedBox(height: 16),
                      GlassmorphicContainer(
                        width: double.infinity,
                        height: 80,
                        borderRadius: 16,
                        blur: 15,
                        alignment: Alignment.center,
                        border: 2,
                        linearGradient: LinearGradient(
                          colors: [
                            AppColors.cardColor.withValues(alpha: 0.5),
                            AppColors.surfaceColor.withValues(alpha: 0.3),
                          ],
                        ),
                        borderGradient: LinearGradient(
                          colors: [
                            AppColors.primaryPurple.withValues(alpha: 0.3),
                            AppColors.secondaryPink.withValues(alpha: 0.3),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppColors.primaryGradient,
                                ),
                                child: const Icon(
                                  Icons.favorite,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _stats.favoriteCharacter,
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Most chatted character',
                                      style: AppTextStyles.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: const Duration(milliseconds: 1200))
                          .slideX(begin: 0.3, end: 0),
                    ],
                  ),
                ),
              ),

            // Logout Button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.error.withValues(alpha: 0.8),
                        AppColors.error,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.error.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        final shouldLogout = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: AppColors.surfaceColor,
                            title: Text(
                              'Logout',
                              style: AppTextStyles.headline2,
                            ),
                            content: Text(
                              'Are you sure you want to logout?',
                              style: AppTextStyles.bodyMedium,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: Text(
                                  'Cancel',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: Text(
                                  'Logout',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.error,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );

                        if (shouldLogout == true && mounted) {
                          final authService = FirebaseAuthService();
                          await authService.signOut();
                          if (mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login',
                              (route) => false,
                            );
                          }
                        }
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout,
                              color: AppColors.textPrimary,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Logout',
                              style: AppTextStyles.button,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Gradient gradient,
    required int index,
  }) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: double.infinity,
      borderRadius: 20,
      blur: 15,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        colors: [
          AppColors.cardColor.withValues(alpha: 0.5),
          AppColors.surfaceColor.withValues(alpha: 0.3),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          AppColors.primaryPurple.withValues(alpha: 0.3),
          AppColors.secondaryPink.withValues(alpha: 0.3),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: gradient,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: AppTextStyles.headline1.copyWith(fontSize: 28),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 900 + (index * 100)))
        .scale(delay: Duration(milliseconds: 900 + (index * 100)));
  }

  Widget _buildAchievementsGrid() {
    final allAchievements = [
      {'id': 'first_message', 'title': 'First Steps', 'icon': Icons.chat_bubble, 'description': 'Send your first message'},
      {'id': 'conversationalist', 'title': 'Conversationalist', 'icon': Icons.chat, 'description': '50 messages sent'},
      {'id': 'code_master', 'title': 'Code Master', 'icon': Icons.code, 'description': '10 code snippets generated'},
      {'id': 'character_collector', 'title': 'Character Collector', 'icon': Icons.auto_awesome, 'description': 'Chat with 5 characters'},
      {'id': 'chat_marathon', 'title': 'Chat Marathon', 'icon': Icons.forum, 'description': '10 chat sessions'},
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: allAchievements.map((achievement) {
        final isUnlocked = _stats.achievements.contains(achievement['id']);
        return _buildAchievementBadge(
          icon: achievement['icon'] as IconData,
          title: achievement['title'] as String,
          description: achievement['description'] as String,
          isUnlocked: isUnlocked,
        );
      }).toList(),
    );
  }

  Widget _buildAchievementBadge({
    required IconData icon,
    required String title,
    required String description,
    required bool isUnlocked,
  }) {
    return Opacity(
      opacity: isUnlocked ? 1.0 : 0.4,
      child: GlassmorphicContainer(
        width: 100,
        height: 120,
        borderRadius: 16,
        blur: 15,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          colors: [
            AppColors.cardColor.withValues(alpha: 0.5),
            AppColors.surfaceColor.withValues(alpha: 0.3),
          ],
        ),
        borderGradient: LinearGradient(
          colors: isUnlocked
              ? [
                  AppColors.primaryPurple.withValues(alpha: 0.5),
                  AppColors.secondaryPink.withValues(alpha: 0.5),
                ]
              : [
                  AppColors.textHint.withValues(alpha: 0.2),
                  AppColors.textHint.withValues(alpha: 0.2),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: isUnlocked
                      ? AppColors.primaryGradient
                      : LinearGradient(
                          colors: [
                            AppColors.textHint.withValues(alpha: 0.3),
                            AppColors.textHint.withValues(alpha: 0.3),
                          ],
                        ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: const Duration(milliseconds: 1100))
        .scale(delay: const Duration(milliseconds: 1100));
  }
}
