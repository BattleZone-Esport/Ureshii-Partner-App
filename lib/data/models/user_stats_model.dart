/// User Statistics Model
class UserStatsModel {
  final int totalMessages;
  final int totalChats;
  final int charactersUnlocked;
  final int codeSnippetsGenerated;
  final String favoriteCharacter;
  final DateTime memberSince;
  final List<String> achievements;

  UserStatsModel({
    required this.totalMessages,
    required this.totalChats,
    required this.charactersUnlocked,
    required this.codeSnippetsGenerated,
    required this.favoriteCharacter,
    required this.memberSince,
    required this.achievements,
  });

  factory UserStatsModel.initial() {
    return UserStatsModel(
      totalMessages: 0,
      totalChats: 0,
      charactersUnlocked: 0,
      codeSnippetsGenerated: 0,
      favoriteCharacter: 'None',
      memberSince: DateTime.now(),
      achievements: [],
    );
  }

  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      totalMessages: json['totalMessages'] as int,
      totalChats: json['totalChats'] as int,
      charactersUnlocked: json['charactersUnlocked'] as int,
      codeSnippetsGenerated: json['codeSnippetsGenerated'] as int,
      favoriteCharacter: json['favoriteCharacter'] as String,
      memberSince: DateTime.parse(json['memberSince'] as String),
      achievements: (json['achievements'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalMessages': totalMessages,
      'totalChats': totalChats,
      'charactersUnlocked': charactersUnlocked,
      'codeSnippetsGenerated': codeSnippetsGenerated,
      'favoriteCharacter': favoriteCharacter,
      'memberSince': memberSince.toIso8601String(),
      'achievements': achievements,
    };
  }

  UserStatsModel copyWith({
    int? totalMessages,
    int? totalChats,
    int? charactersUnlocked,
    int? codeSnippetsGenerated,
    String? favoriteCharacter,
    DateTime? memberSince,
    List<String>? achievements,
  }) {
    return UserStatsModel(
      totalMessages: totalMessages ?? this.totalMessages,
      totalChats: totalChats ?? this.totalChats,
      charactersUnlocked: charactersUnlocked ?? this.charactersUnlocked,
      codeSnippetsGenerated: codeSnippetsGenerated ?? this.codeSnippetsGenerated,
      favoriteCharacter: favoriteCharacter ?? this.favoriteCharacter,
      memberSince: memberSince ?? this.memberSince,
      achievements: achievements ?? this.achievements,
    );
  }

  // Calculate user level based on total messages
  int get level {
    return (totalMessages / 10).floor() + 1;
  }

  // Calculate progress to next level
  double get levelProgress {
    final messagesInCurrentLevel = totalMessages % 10;
    return messagesInCurrentLevel / 10;
  }

  // Get rank title based on level
  String get rankTitle {
    if (level < 5) return 'Novice Coder';
    if (level < 10) return 'Junior Developer';
    if (level < 20) return 'Senior Developer';
    if (level < 30) return 'Tech Lead';
    if (level < 50) return 'Architect';
    return 'Legendary Developer';
  }
}
