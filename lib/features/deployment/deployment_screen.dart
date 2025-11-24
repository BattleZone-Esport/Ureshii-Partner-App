import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../core/constants/colors.dart';
import '../../core/theme/text_styles.dart';

enum DeploymentPlatform { vercel, railway }

enum DeploymentStatus { idle, building, success, failed }

class DeploymentScreen extends StatefulWidget {
  const DeploymentScreen({super.key});

  @override
  State<DeploymentScreen> createState() => _DeploymentScreenState();
}

class _DeploymentScreenState extends State<DeploymentScreen> {
  DeploymentPlatform _selectedPlatform = DeploymentPlatform.vercel;
  
  final TextEditingController _repoController = TextEditingController();
  final TextEditingController _projectNameController = TextEditingController();
  final List<String> _buildLogs = [];
  String? _deploymentUrl;
  
  bool _isDeploying = false;

  @override
  void dispose() {
    _repoController.dispose();
    _projectNameController.dispose();
    super.dispose();
  }

  Future<void> _startDeployment() async {
    if (_repoController.text.isEmpty) {
      _showError('Please enter a repository URL');
      return;
    }

    setState(() {
      _isDeploying = true;
      _buildLogs.clear();
      _deploymentUrl = null;
    });

    // Simulate deployment process
    final logs = [
      '🔍 Connecting to ${_selectedPlatform == DeploymentPlatform.vercel ? 'Vercel' : 'Railway'}...',
      '✅ Connected successfully',
      '📦 Cloning repository...',
      '✅ Repository cloned',
      '🔨 Installing dependencies...',
      '✅ Dependencies installed',
      '🏗️ Building project...',
      '⚙️ Running build scripts...',
      '✅ Build completed successfully',
      '🚀 Deploying to production...',
      '✅ Deployment successful!',
    ];

    for (final log in logs) {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() {
          _buildLogs.add(log);
        });
      }
    }

    // Generate mock deployment URL
    final projectName = _projectNameController.text.isEmpty
        ? 'my-project'
        : _projectNameController.text.toLowerCase().replaceAll(' ', '-');
    
    final url = _selectedPlatform == DeploymentPlatform.vercel
        ? 'https://$projectName.vercel.app'
        : 'https://$projectName.up.railway.app';

    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      setState(() {
        _deploymentUrl = url;
        _isDeploying = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
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
          'Deploy Project',
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
              
              // Platform Selection
              Text(
                'Select Platform',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: _buildPlatformCard(
                      platform: DeploymentPlatform.vercel,
                      icon: Icons.cloud,
                      name: 'Vercel',
                      description: 'Fast & reliable',
                    ).animate().fadeIn(delay: const Duration(milliseconds: 100)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPlatformCard(
                      platform: DeploymentPlatform.railway,
                      icon: Icons.train,
                      name: 'Railway',
                      description: 'Full stack apps',
                    ).animate().fadeIn(delay: const Duration(milliseconds: 200)),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Repository URL
              Text(
                'Repository Details',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: 12),
              
              _buildInputCard(
                controller: _repoController,
                label: 'GitHub Repository URL',
                hint: 'https://github.com/username/repo',
                icon: Icons.link,
              ).animate().fadeIn(delay: const Duration(milliseconds: 300)),
              
              const SizedBox(height: 16),
              
              _buildInputCard(
                controller: _projectNameController,
                label: 'Project Name (Optional)',
                hint: 'my-awesome-project',
                icon: Icons.label,
              ).animate().fadeIn(delay: const Duration(milliseconds: 400)),
              
              const SizedBox(height: 24),
              
              // Build Logs Section
              if (_buildLogs.isNotEmpty) ...[
                Text(
                  'Build Logs',
                  style: AppTextStyles.headline2,
                ),
                const SizedBox(height: 12),
                
                _buildLogsCard().animate().fadeIn().slideY(begin: 0.2, end: 0),
                
                const SizedBox(height: 24),
              ],
              
              // Deployment URL
              if (_deploymentUrl != null) ...[
                _buildDeploymentUrlCard()
                    .animate()
                    .fadeIn()
                    .scale(
                      curve: Curves.elasticOut,
                      duration: const Duration(milliseconds: 600),
                    ),
                
                const SizedBox(height: 24),
              ],
              
              // Deploy Button
              _buildDeployButton()
                  .animate()
                  .fadeIn(delay: const Duration(milliseconds: 500))
                  .scale(delay: const Duration(milliseconds: 500)),
              
              const SizedBox(height: 24),
              
              // Info Card
              _buildInfoCard().animate().fadeIn(delay: const Duration(milliseconds: 600)),
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
          AppColors.accentBlue.withValues(alpha: 0.3),
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
                  colors: [AppColors.accentGreen, AppColors.accentBlue],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.rocket_launch,
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
                    'Deploy to Cloud',
                    style: AppTextStyles.headline2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'One-click deployment to production',
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

  Widget _buildPlatformCard({
    required DeploymentPlatform platform,
    required IconData icon,
    required String name,
    required String description,
  }) {
    final isSelected = _selectedPlatform == platform;
    
    return GlassmorphicContainer(
      width: double.infinity,
      height: 120,
      borderRadius: 16,
      blur: 10,
      alignment: Alignment.center,
      border: isSelected ? 2.5 : 1.5,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isSelected
            ? [
                AppColors.primaryPurple.withValues(alpha: 0.3),
                AppColors.accentBlue.withValues(alpha: 0.3),
              ]
            : [
                AppColors.surfaceColor.withValues(alpha: 0.4),
                AppColors.cardColor.withValues(alpha: 0.3),
              ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isSelected
            ? [
                AppColors.primaryPurple.withValues(alpha: 0.8),
                AppColors.accentBlue.withValues(alpha: 0.8),
              ]
            : [
                AppColors.primaryPurple.withValues(alpha: 0.2),
                AppColors.accentBlue.withValues(alpha: 0.2),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedPlatform = platform;
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? AppColors.primaryGradient
                        : LinearGradient(
                            colors: [
                              AppColors.textSecondary.withValues(alpha: 0.3),
                              AppColors.textSecondary.withValues(alpha: 0.3),
                            ],
                          ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.primaryPurple : AppColors.textPrimary,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
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
          AppColors.accentGreen.withValues(alpha: 0.2),
          AppColors.accentBlue.withValues(alpha: 0.2),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accentGreen, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
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

  Widget _buildLogsCard() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 300,
      borderRadius: 16,
      blur: 10,
      alignment: Alignment.topLeft,
      border: 1.5,
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
          AppColors.accentBlue.withValues(alpha: 0.2),
          AppColors.accentGreen.withValues(alpha: 0.2),
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
                  Icons.terminal,
                  color: AppColors.accentGreen,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Console Output',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildLogs.map((log) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        log,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontFamily: 'monospace',
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeploymentUrlCard() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 100,
      borderRadius: 16,
      blur: 10,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.accentGreen.withValues(alpha: 0.3),
          AppColors.accentBlue.withValues(alpha: 0.3),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.accentGreen.withValues(alpha: 0.5),
          AppColors.accentBlue.withValues(alpha: 0.5),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.accentGreen, AppColors.accentBlue],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.textPrimary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Deployment Successful! 🎉',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _deploymentUrl ?? '',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accentBlue,
                      decoration: TextDecoration.underline,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.open_in_new,
                color: AppColors.accentGreen,
              ),
              onPressed: () {
                // Open URL in browser
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeployButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: _isDeploying
            ? LinearGradient(
                colors: [
                  AppColors.accentGreen.withValues(alpha: 0.3),
                  AppColors.accentBlue.withValues(alpha: 0.3),
                ],
              )
            : const LinearGradient(
                colors: [AppColors.accentGreen, AppColors.accentBlue],
              ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGreen.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isDeploying ? null : _startDeployment,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: _isDeploying
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
                        Icons.rocket_launch,
                        color: AppColors.textPrimary,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Deploy Now',
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

  Widget _buildInfoCard() {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 180,
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
                  Icons.info_outline,
                  color: AppColors.accentBlue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Deployment Info',
                  style: AppTextStyles.headline2,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.check, 'Automatic SSL certificates'),
            _buildInfoRow(Icons.check, 'Global CDN distribution'),
            _buildInfoRow(Icons.check, 'Zero-config deployment'),
            _buildInfoRow(Icons.check, 'Instant rollbacks'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.accentGreen,
            size: 16,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}
