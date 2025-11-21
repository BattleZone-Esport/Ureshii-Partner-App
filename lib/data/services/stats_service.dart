import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_stats_model.dart';

/// Statistics Service for tracking user activity
class StatsService {
  static const String _statsBoxName = 'user_stats';
  static const String _statsKey = 'stats';

  /// Initialize the stats service
  static Future<void> init() async {
    await Hive.openBox(_statsBoxName);
  }

  /// Get current user stats
  static UserStatsModel getStats() {
    final box = Hive.box(_statsBoxName);
    final statsJson = box.get(_statsKey);
    
    if (statsJson == null) {
      final initialStats = UserStatsModel.initial();
      saveStats(initialStats);
      return initialStats;
    }
    
    return UserStatsModel.fromJson(Map<String, dynamic>.from(statsJson));
  }

  /// Save user stats
  static Future<void> saveStats(UserStatsModel stats) async {
    final box = Hive.box(_statsBoxName);
    await box.put(_statsKey, stats.toJson());
  }

  /// Increment message count
  static Future<void> incrementMessages() async {
    final stats = getStats();
    await saveStats(stats.copyWith(
      totalMessages: stats.totalMessages + 1,
    ));
  }

  /// Increment chat count
  static Future<void> incrementChats() async {
    final stats = getStats();
    await saveStats(stats.copyWith(
      totalChats: stats.totalChats + 1,
    ));
  }

  /// Track character usage
  static Future<void> trackCharacterUsage(String characterName) async {
    final stats = getStats();
    // Update favorite character logic here
    await saveStats(stats.copyWith(
      favoriteCharacter: characterName,
    ));
  }

  /// Increment code snippets generated
  static Future<void> incrementCodeSnippets() async {
    final stats = getStats();
    await saveStats(stats.copyWith(
      codeSnippetsGenerated: stats.codeSnippetsGenerated + 1,
    ));
  }

  /// Unlock character
  static Future<void> unlockCharacter() async {
    final stats = getStats();
    await saveStats(stats.copyWith(
      charactersUnlocked: stats.charactersUnlocked + 1,
    ));
  }

  /// Add achievement
  static Future<void> addAchievement(String achievement) async {
    final stats = getStats();
    if (!stats.achievements.contains(achievement)) {
      final newAchievements = List<String>.from(stats.achievements)
        ..add(achievement);
      await saveStats(stats.copyWith(achievements: newAchievements));
    }
  }

  /// Check and award achievements
  static Future<void> checkAchievements() async {
    final stats = getStats();
    
    // First Message
    if (stats.totalMessages >= 1 && !stats.achievements.contains('first_message')) {
      await addAchievement('first_message');
    }
    
    // Conversationalist (50 messages)
    if (stats.totalMessages >= 50 && !stats.achievements.contains('conversationalist')) {
      await addAchievement('conversationalist');
    }
    
    // Code Master (10 code snippets)
    if (stats.codeSnippetsGenerated >= 10 && !stats.achievements.contains('code_master')) {
      await addAchievement('code_master');
    }
    
    // Character Collector (5 characters)
    if (stats.charactersUnlocked >= 5 && !stats.achievements.contains('character_collector')) {
      await addAchievement('character_collector');
    }
    
    // Chat Marathon (10 chats)
    if (stats.totalChats >= 10 && !stats.achievements.contains('chat_marathon')) {
      await addAchievement('chat_marathon');
    }
  }
}
