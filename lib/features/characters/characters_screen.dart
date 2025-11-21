import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../core/constants/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../data/models/character_model.dart';
import '../../data/repositories/character_repository.dart';
import 'character_detail_screen.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> with TickerProviderStateMixin {
  final List<CharacterModel> _characters = CharacterRepository.getAllCharacters();
  final List<String> _animeNames = CharacterRepository.getAllAnimeNames();
  String _selectedAnime = 'All';
  bool _isGridView = true;
  late AnimationController _filterController;

  @override
  void initState() {
    super.initState();
    _filterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _filterController.dispose();
    super.dispose();
  }

  List<CharacterModel> get _filteredCharacters {
    if (_selectedAnime == 'All') return _characters;
    return _characters.where((c) => c.anime == _selectedAnime).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Epic Header with Parallax Effect
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.surfaceColor,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Character Gallery',
                  style: AppTextStyles.headline1.copyWith(fontSize: 20),
                ),
                background: Container(
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
                      ...List.generate(
                        20,
                        (index) => Positioned(
                          left: (index * 50.0) % 400,
                          top: (index * 30.0) % 200,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.primaryPurple.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                          )
                              .animate(
                                onPlay: (controller) => controller.repeat(reverse: true),
                              )
                              .fadeIn(
                                duration: Duration(milliseconds: 1000 + (index * 100)),
                              )
                              .scale(
                                duration: Duration(milliseconds: 1500 + (index * 50)),
                              ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              size: 48,
                              color: AppColors.primaryPurple,
                            )
                                .animate(
                                  onPlay: (controller) => controller.repeat(),
                                )
                                .rotate(duration: const Duration(seconds: 3)),
                            const SizedBox(height: 12),
                            Text(
                              '${_filteredCharacters.length} Characters',
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Filter Section
            SliverToBoxAdapter(
              child: Container(
                height: 60,
                margin: const EdgeInsets.all(16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: _animeNames.length + 1,
                  itemBuilder: (context, index) {
                    final anime = index == 0 ? 'All' : _animeNames[index - 1];
                    final isSelected = _selectedAnime == anime;

                    return _buildFilterChip(anime, isSelected, index);
                  },
                ),
              )
                  .animate()
                  .slideX(begin: -0.5, end: 0)
                  .fadeIn(),
            ),

            // Character Grid
            _isGridView ? _buildGridView() : _buildListView(),
          ],
        ),
      ),

      // View Toggle FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isGridView = !_isGridView;
          });
        },
        child: Icon(_isGridView ? Icons.list : Icons.grid_view),
      )
          .animate()
          .scale(duration: const Duration(milliseconds: 400))
          .fadeIn(),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedAnime = label;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected
                ? AppColors.primaryGradient
                : null,
            color: isSelected ? null : AppColors.surfaceColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
      )
          .animate()
          .fadeIn(delay: Duration(milliseconds: index * 50))
          .slideX(begin: 0.3, end: 0),
    );
  }

  Widget _buildGridView() {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final character = _filteredCharacters[index];
            return _buildCharacterCard(character, index);
          },
          childCount: _filteredCharacters.length,
        ),
      ),
    );
  }

  Widget _buildListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final character = _filteredCharacters[index];
          return _buildCharacterListTile(character, index);
        },
        childCount: _filteredCharacters.length,
      ),
    );
  }

  Widget _buildCharacterCard(CharacterModel character, int index) {
    return Hero(
      tag: 'character_${character.id}',
      child: GlassmorphicContainer(
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterDetailScreen(character: character),
                ),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Character Avatar
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      gradient: AppColors.primaryGradient,
                    ),
                    child: Stack(
                      children: [
                        if (character.avatarUrl != null)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                            child: Image.network(
                              character.avatarUrl!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 48,
                                    color: AppColors.textPrimary,
                                  ),
                                );
                              },
                            ),
                          ),
                        // Glow effect
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  AppColors.cardColor.withValues(alpha: 0.9),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Character Info
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          character.name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          character.anime,
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        // Traits badges
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: character.traits.take(2).map((trait) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryPurple.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                trait,
                                style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
          .animate()
          .fadeIn(delay: Duration(milliseconds: index * 50))
          .scale(
            delay: Duration(milliseconds: index * 50),
            curve: Curves.easeOutBack,
          )
          .shimmer(
            delay: Duration(milliseconds: index * 50 + 500),
            duration: const Duration(milliseconds: 1000),
          ),
    );
  }

  Widget _buildCharacterListTile(CharacterModel character, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 100,
        borderRadius: 16,
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterDetailScreen(character: character),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: AppColors.primaryGradient,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: character.avatarUrl != null
                          ? Image.network(
                              character.avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  size: 36,
                                  color: AppColors.textPrimary,
                                );
                              },
                            )
                          : const Icon(
                              Icons.person,
                              size: 36,
                              color: AppColors.textPrimary,
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          character.name,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          character.anime,
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          character.traits.take(3).join(' • '),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primaryPurple,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Arrow
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primaryPurple,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      )
          .animate()
          .fadeIn(delay: Duration(milliseconds: index * 30))
          .slideX(begin: 0.3, end: 0, delay: Duration(milliseconds: index * 30)),
    );
  }
}
