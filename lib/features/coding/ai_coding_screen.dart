import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../../core/constants/colors.dart';
import '../../core/theme/text_styles.dart';
import '../../data/services/openrouter_service.dart';

class AICodingScreen extends StatefulWidget {
  const AICodingScreen({super.key});

  @override
  State<AICodingScreen> createState() => _AICodingScreenState();
}

class _AICodingScreenState extends State<AICodingScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final ScrollController _codeScrollController = ScrollController();
  final OpenRouterService _aiService = OpenRouterService();
  
  bool _isGenerating = false;
  String _selectedMode = 'generate'; // generate, explain, debug, refactor
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _promptController.dispose();
    _codeController.dispose();
    _codeScrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _generateCode() async {
    if (_promptController.text.trim().isEmpty) {
      _showSnackBar('Please enter a prompt', isError: true);
      return;
    }

    setState(() => _isGenerating = true);

    try {
      final prompt = _buildPrompt();
      final response = await _aiService.generateCode(prompt);
      
      setState(() {
        _codeController.text = response;
      });
      
      _showSnackBar('Code generated successfully!');
    } catch (e) {
      _showSnackBar('Failed to generate code: $e', isError: true);
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  String _buildPrompt() {
    final userPrompt = _promptController.text.trim();
    final existingCode = _codeController.text.trim();

    switch (_selectedMode) {
      case 'generate':
        return 'Generate production-ready code for: $userPrompt\n\nProvide clean, well-documented code with comments.';
      case 'explain':
        return 'Explain this code in detail:\n\n```\n$existingCode\n```\n\nProvide a clear explanation of what it does and how it works.';
      case 'debug':
        return 'Debug and fix this code:\n\n```\n$existingCode\n```\n\nUser issue: $userPrompt\n\nProvide the fixed code with explanations of what was wrong.';
      case 'refactor':
        return 'Refactor this code for better performance and maintainability:\n\n```\n$existingCode\n```\n\nFocus on: $userPrompt';
      default:
        return userPrompt;
    }
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _codeController.text));
    _showSnackBar('Code copied to clipboard!');
  }

  void _clearCode() {
    setState(() {
      _codeController.clear();
      _promptController.clear();
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.primaryPurple,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceColor,
        elevation: 0,
        title: Text(
          'AI Coding Assistant',
          style: AppTextStyles.headline2,
        ),
        actions: [
          if (_codeController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.copy),
              onPressed: _copyCode,
              tooltip: 'Copy Code',
            ),
          if (_codeController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearCode,
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Mode Selector
            _buildModeSelector(),

            // Input Section
            _buildInputSection(),

            // Generate Button
            _buildGenerateButton(),

            // Code Output
            Expanded(
              child: _buildCodeEditor(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 60,
        borderRadius: 16,
        blur: 15,
        alignment: Alignment.center,
        border: 2,
        linearGradient: LinearGradient(
          colors: [
            AppColors.surfaceColor.withValues(alpha: 0.5),
            AppColors.cardColor.withValues(alpha: 0.3),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            AppColors.primaryPurple.withValues(alpha: 0.3),
            AppColors.secondaryPink.withValues(alpha: 0.3),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildModeButton('Generate', 'generate', Icons.code),
            _buildModeButton('Explain', 'explain', Icons.info),
            _buildModeButton('Debug', 'debug', Icons.bug_report),
            _buildModeButton('Refactor', 'refactor', Icons.auto_fix_high),
          ],
        ),
      ),
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  Widget _buildModeButton(String label, String mode, IconData icon) {
    final isSelected = _selectedMode == mode;
    return GestureDetector(
      onTap: () => setState(() => _selectedMode = mode),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.primaryGradient : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassmorphicContainer(
        width: double.infinity,
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
          colors: [
            AppColors.primaryPurple.withValues(alpha: 0.3),
            AppColors.secondaryPink.withValues(alpha: 0.3),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _promptController,
            maxLines: 3,
            style: AppTextStyles.bodyMedium,
            decoration: InputDecoration(
              hintText: _getPlaceholderText(),
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 100));
  }

  String _getPlaceholderText() {
    switch (_selectedMode) {
      case 'generate':
        return 'Describe what you want to build...\nExample: Create a REST API with authentication';
      case 'explain':
        return 'Paste your code below and it will be explained...';
      case 'debug':
        return 'Describe the issue you\'re facing...\nExample: Getting null pointer exception';
      case 'refactor':
        return 'What do you want to improve?\nExample: Optimize for performance';
      default:
        return 'Enter your prompt...';
    }
  }

  Widget _buildGenerateButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurple.withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isGenerating ? null : _generateCode,
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: _isGenerating
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.textPrimary,
                              strokeWidth: 2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Generating...',
                            style: AppTextStyles.button,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: AppColors.textPrimary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _getButtonText(),
                            style: AppTextStyles.button,
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 200));
  }

  String _getButtonText() {
    switch (_selectedMode) {
      case 'generate':
        return 'Generate Code';
      case 'explain':
        return 'Explain Code';
      case 'debug':
        return 'Debug & Fix';
      case 'refactor':
        return 'Refactor Code';
      default:
        return 'Generate';
    }
  }

  Widget _buildCodeEditor() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: double.infinity,
        borderRadius: 16,
        blur: 15,
        alignment: Alignment.topLeft,
        border: 2,
        linearGradient: LinearGradient(
          colors: [
            AppColors.cardColor.withValues(alpha: 0.7),
            AppColors.surfaceColor.withValues(alpha: 0.5),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            AppColors.primaryPurple.withValues(alpha: 0.3),
            AppColors.secondaryPink.withValues(alpha: 0.3),
          ],
        ),
        child: _codeController.text.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.code,
                      size: 64,
                      color: AppColors.textHint.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your generated code will appear here',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ],
                ),
              )
            : Scrollbar(
                controller: _codeScrollController,
                child: SingleChildScrollView(
                  controller: _codeScrollController,
                  padding: const EdgeInsets.all(16),
                  child: SelectableText(
                    _codeController.text,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
              ),
      ),
    ).animate().fadeIn(delay: const Duration(milliseconds: 300));
  }
}
