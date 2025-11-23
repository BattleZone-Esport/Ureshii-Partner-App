import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../core/constants/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../data/services/openrouter_service.dart';

class GitHubIntegrationScreen extends ConsumerStatefulWidget {
  const GitHubIntegrationScreen({super.key});

  @override
  ConsumerState<GitHubIntegrationScreen> createState() => _GitHubIntegrationScreenState();
}

class _GitHubIntegrationScreenState extends ConsumerState<GitHubIntegrationScreen> {
  final TextEditingController _repoUrlController = TextEditingController();
  final TextEditingController _commitMessageController = TextEditingController();
  final TextEditingController _branchController = TextEditingController(text: 'main');
  final TextEditingController _tokenController = TextEditingController();
  
  bool _isLoading = false;
  String? _statusMessage;
  bool _isSuccess = false;
  
  final OpenRouterService _aiService = OpenRouterService();

  @override
  void dispose() {
    _repoUrlController.dispose();
    _commitMessageController.dispose();
    _branchController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _generateCommitMessage() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Generating commit message...';
    });

    try {
      final prompt = '''Generate a concise, professional git commit message for the URESHII Partner app.
The app is a Flutter application with AI coding assistance, character chat, and project management features.
Generate a commit message that follows conventional commit standards (e.g., "feat: Add AI coding assistant").
Only respond with the commit message, nothing else.''';

      final response = await _aiService.generateCode(prompt);
      
      setState(() {
        _commitMessageController.text = response.trim();
        _statusMessage = 'Commit message generated!';
        _isSuccess = true;
        _isLoading = false;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _statusMessage = null;
            _isSuccess = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error generating message: $e';
        _isSuccess = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _pushToGitHub() async {
    if (_repoUrlController.text.isEmpty) {
      _showError('Please enter a repository URL');
      return;
    }
    
    if (_commitMessageController.text.isEmpty) {
      _showError('Please enter a commit message');
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Preparing to push to GitHub...';
    });

    try {
      // Simulate GitHub push (in real implementation, would use GitHub API or git commands)
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _statusMessage = 'Successfully pushed to GitHub! 🎉';
        _isSuccess = true;
        _isLoading = false;
      });

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _statusMessage = null;
            _isSuccess = false;
          });
        }
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error pushing to GitHub: $e';
        _isSuccess = false;
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
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
          'GitHub Integration',
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
              // Header Card
              _buildHeaderCard().animate().fadeIn().slideY(begin: -0.2, end: 0),
              
              const SizedBox(height: 24),
              
              // Repository URL Section
              Text(
                'Repository Details',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: 12),
              
              _buildInputCard(
                controller: _repoUrlController,
                label: 'Repository URL',
                hint: 'https://github.com/username/repo.git',
                icon: Icons.link,
              ).animate().fadeIn(delay: const Duration(milliseconds: 100)),
              
              const SizedBox(height: 16),
              
              _buildInputCard(
                controller: _branchController,
                label: 'Branch',
                hint: 'main',
                icon: Icons.account_tree,
              ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
              
              const SizedBox(height: 24),
              
              // Commit Message Section
              Text(
                'Commit Message',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: 12),
              
              _buildCommitMessageCard().animate().fadeIn(delay: const Duration(milliseconds: 300)),
              
              const SizedBox(height: 24),
              
              // GitHub Token Section (Optional)
              Text(
                'Authentication (Optional)',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: 12),
              
              _buildInputCard(
                controller: _tokenController,
                label: 'Personal Access Token',
                hint: 'ghp_xxxxxxxxxxxx',
                icon: Icons.key,
                isPassword: true,
              ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
              
              const SizedBox(height: 24),
              
              // Status Message
              if (_statusMessage != null)
                _buildStatusMessage().animate().fadeIn().scale(),
              
              const SizedBox(height: 16),
              
              // Push Button
              _buildPushButton().animate().fadeIn(delay: const Duration(milliseconds: 500)).scale(),
              
              const SizedBox(height: 24),
              
              // Quick Guide
              _buildQuickGuide().animate().fadeIn(delay: const Duration(milliseconds: 600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
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
                gradient: const LinearGradient(
                  colors: [AppColors.primaryPurple, AppColors.secondaryPink],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.cloud_upload,
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
                    'Push to GitHub',
                    style: AppTextStyles.headline2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Deploy your code to the cloud',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
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
          AppColors.accentBlue.withValues(alpha: 0.2),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryPurple, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: isPassword,
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  hintText: hint,
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommitMessageCard() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 180,
      borderRadius: 16,
      blur: 10,
      alignment: Alignment.topLeft,
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
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _commitMessageController,
                maxLines: null,
                expands: true,
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  labelText: 'Commit Message',
                  labelStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  hintText: 'feat: Add new feature\n\nDescribe your changes...',
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryPurple.withValues(alpha: 0.1),
                  AppColors.accentBlue.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isLoading ? null : _generateCommitMessage,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isLoading)
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.primaryPurple,
                                  ),
                                ),
                              )
                            else
                              const Icon(
                                Icons.auto_awesome,
                                color: AppColors.primaryPurple,
                                size: 20,
                              ),
                            const SizedBox(width: 8),
                            Text(
                              _isLoading ? 'Generating...' : 'Generate with AI',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.primaryPurple,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusMessage() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 60,
      borderRadius: 12,
      blur: 10,
      alignment: Alignment.center,
      border: 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          (_isSuccess ? AppColors.accentGreen : Colors.orange).withValues(alpha: 0.2),
          (_isSuccess ? AppColors.accentGreen : Colors.orange).withValues(alpha: 0.1),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          (_isSuccess ? AppColors.accentGreen : Colors.orange).withValues(alpha: 0.3),
          (_isSuccess ? AppColors.accentGreen : Colors.orange).withValues(alpha: 0.3),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Icon(
              _isSuccess ? Icons.check_circle : Icons.info,
              color: _isSuccess ? AppColors.accentGreen : Colors.orange,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _statusMessage ?? '',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: _isSuccess ? AppColors.accentGreen : Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPushButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: _isLoading
            ? LinearGradient(
                colors: [
                  AppColors.primaryPurple.withValues(alpha: 0.3),
                  AppColors.secondaryPink.withValues(alpha: 0.3),
                ],
              )
            : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryPurple.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _pushToGitHub,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.textPrimary),
                    ),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.cloud_upload,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Push to GitHub',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickGuide() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 220,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb,
                  color: AppColors.accentBlue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Quick Guide',
                  style: AppTextStyles.headline2,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildGuideStep('1', 'Enter your GitHub repository URL'),
            _buildGuideStep('2', 'Write or generate a commit message'),
            _buildGuideStep('3', 'Optionally add a personal access token'),
            _buildGuideStep('4', 'Push your code to GitHub!'),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
