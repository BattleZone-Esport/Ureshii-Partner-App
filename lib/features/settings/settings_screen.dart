import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../core/constants/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../core/constants/api_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController(
    text: ApiConfig.openRouterApiKey,
  );
  
  bool _obscureApiKey = true;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = true;
  final String _selectedModel = ApiConfig.chatModel;

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard!'),
        backgroundColor: AppColors.accentGreen,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: AppTextStyles.headline2,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              _buildProfileCard().animate().fadeIn().slideY(begin: -0.2, end: 0),
              
              const SizedBox(height: 32),
              
              // API Configuration Section
              Text(
                'API Configuration',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: 12),
              
              _buildApiKeyCard().animate().fadeIn(delay: const Duration(milliseconds: 100)),
              
              const SizedBox(height: 12),
              
              _buildModelSelectionCard().animate().fadeIn(delay: const Duration(milliseconds: 200)),
              
              const SizedBox(height: 32),
              
              // App Settings Section
              Text(
                'App Settings',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: 12),
              
              _buildSettingsCard(
                icon: Icons.notifications,
                title: 'Notifications',
                subtitle: 'Get notified about updates',
                trailing: Switch(
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                    });
                  },
                  activeTrackColor: AppColors.accentGreen,
                ),
              ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
              
              const SizedBox(height: 12),
              
              _buildSettingsCard(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                subtitle: 'Use dark theme',
                trailing: Switch(
                  value: _darkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      _darkModeEnabled = value;
                    });
                  },
                  activeTrackColor: AppColors.accentGreen,
                ),
              ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
              
              const SizedBox(height: 32),
              
              // About Section
              Text(
                'About',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: 12),
              
              _buildAboutCard().animate().fadeIn(delay: const Duration(milliseconds: 500)),
              
              const SizedBox(height: 32),
              
              // Models Information Section
              Text(
                'Available AI Models',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: 12),
              
              _buildModelsInfoCard().animate().fadeIn(delay: const Duration(milliseconds: 600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 120,
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
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: AppColors.textPrimary,
                size: 36,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'URESHII Partner',
                    style: AppTextStyles.headline2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'AI Development Assistant',
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accentGreen.withValues(alpha: 0.3),
                          AppColors.accentBlue.withValues(alpha: 0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Pro Account',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.accentGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApiKeyCard() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 100,
      borderRadius: 16,
      blur: 10,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.surfaceColor.withValues(alpha: 0.4),
          AppColors.cardColor.withValues(alpha: 0.3),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primaryPurple.withValues(alpha: 0.2),
          AppColors.accentBlue.withValues(alpha: 0.2),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.key,
                  color: AppColors.primaryPurple,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'OpenRouter API Key',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _obscureApiKey
                        ? '•' * 40
                        : _apiKeyController.text,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontFamily: 'monospace',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _obscureApiKey ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.primaryPurple,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureApiKey = !_obscureApiKey;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.copy,
                    color: AppColors.accentGreen,
                    size: 20,
                  ),
                  onPressed: () {
                    _copyToClipboard(_apiKeyController.text);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelSelectionCard() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 80,
      borderRadius: 16,
      blur: 10,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.surfaceColor.withValues(alpha: 0.4),
          AppColors.cardColor.withValues(alpha: 0.3),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.accentGreen.withValues(alpha: 0.2),
          AppColors.accentBlue.withValues(alpha: 0.2),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            const Icon(
              Icons.smart_toy,
              color: AppColors.accentGreen,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Default Chat Model',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _selectedModel,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 80,
      borderRadius: 16,
      blur: 10,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.surfaceColor.withValues(alpha: 0.4),
          AppColors.cardColor.withValues(alpha: 0.3),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primaryPurple.withValues(alpha: 0.2),
          AppColors.secondaryPink.withValues(alpha: 0.2),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryPurple, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 160,
      borderRadius: 16,
      blur: 10,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.cardColor.withValues(alpha: 0.3),
          AppColors.surfaceColor.withValues(alpha: 0.2),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.accentBlue.withValues(alpha: 0.2),
          AppColors.accentGreen.withValues(alpha: 0.2),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Version',
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  '1.0.0',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Build',
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  '2024.01.01',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Developer',
                  style: AppTextStyles.bodyMedium,
                ),
                Text(
                  'URESHII Team',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelsInfoCard() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 300,
      borderRadius: 16,
      blur: 10,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.cardColor.withValues(alpha: 0.3),
          AppColors.surfaceColor.withValues(alpha: 0.2),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.primaryPurple.withValues(alpha: 0.2),
          AppColors.accentPink.withValues(alpha: 0.2),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildModelInfo(
              '🔧 Coding',
              ApiConfig.codingModel,
              'Code generation & refactoring',
            ),
            const SizedBox(height: 16),
            _buildModelInfo(
              '💬 Chat',
              ApiConfig.chatModel,
              'General conversation',
            ),
            const SizedBox(height: 16),
            _buildModelInfo(
              '🎭 Roleplay',
              ApiConfig.roleplayModel,
              'Character interactions',
            ),
            const SizedBox(height: 16),
            _buildModelInfo(
              '🧠 Reasoning',
              ApiConfig.reasoningModel,
              'Complex problem solving',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModelInfo(String emoji, String model, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                model,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: Text(
            description,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
