import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../core/constants/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../data/models/character_model.dart';
import '../chat/chat_screen.dart';

class CharacterDetailScreen extends StatelessWidget {
  final CharacterModel character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Epic Hero Image Header
          SliverAppBar(
            expandedHeight: 400,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.surfaceColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'character_${character.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Character Image
                    if (character.avatarUrl != null)
                      Image.network(
                        character.avatarUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.person,
                                size: 100,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        },
                      ),

                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.backgroundColor.withValues(alpha: 0.7),
                            AppColors.backgroundColor,
                          ],
                          stops: const [0.0, 0.7, 1.0],
                        ),
                      ),
                    ),

                    // Character Name Badge
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: GlassmorphicContainer(
                        width: double.infinity,
                        height: 100,
                        borderRadius: 20,
                        blur: 20,
                        alignment: Alignment.center,
                        border: 2,
                        linearGradient: LinearGradient(
                          colors: [
                            AppColors.cardColor.withValues(alpha: 0.7),
                            AppColors.surfaceColor.withValues(alpha: 0.5),
                          ],
                        ),
                        borderGradient: LinearGradient(
                          colors: [
                            AppColors.primaryPurple.withValues(alpha: 0.5),
                            AppColors.secondaryPink.withValues(alpha: 0.5),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                character.name,
                                style: AppTextStyles.headline1,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                character.anime,
                                style: AppTextStyles.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(delay: const Duration(milliseconds: 300))
                          .slideY(begin: 0.3, end: 0),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Traits Section
                  Text(
                    'Personality Traits',
                    style: AppTextStyles.headline2,
                  )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 400))
                      .slideX(begin: -0.2, end: 0),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: character.traits.asMap().entries.map((entry) {
                      final index = entry.key;
                      final trait = entry.value;
                      return _buildTraitChip(trait, index);
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Personality Description
                  Text(
                    'About',
                    style: AppTextStyles.headline2,
                  )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 600))
                      .slideX(begin: -0.2, end: 0),
                  const SizedBox(height: 16),
                  GlassmorphicContainer(
                    width: double.infinity,
                    height: 0,
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
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        character.personality,
                        style: AppTextStyles.bodyLarge,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 700))
                      .scale(delay: const Duration(milliseconds: 700)),

                  const SizedBox(height: 32),

                  // Start Chat Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryPurple.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(character: character),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.chat_bubble,
                                  color: AppColors.textPrimary,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Start Conversation',
                                  style: AppTextStyles.button,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: const Duration(milliseconds: 800))
                      .scale(delay: const Duration(milliseconds: 800))
                      .shimmer(
                        delay: const Duration(milliseconds: 1200),
                        duration: const Duration(seconds: 2),
                      ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTraitChip(String trait, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryPurple.withValues(alpha: 0.3),
            AppColors.secondaryPink.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryPurple.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        trait,
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: 500 + (index * 50)))
        .scale(
          delay: Duration(milliseconds: 500 + (index * 50)),
          curve: Curves.easeOutBack,
        );
  }
}
