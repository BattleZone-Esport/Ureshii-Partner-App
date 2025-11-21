/// Character Model for Anime Character Roleplay
class CharacterModel {
  final String id;
  final String name;
  final String anime;
  final String? avatarUrl;
  final String personality;
  final List<String> traits;
  final String systemPrompt;

  CharacterModel({
    required this.id,
    required this.name,
    required this.anime,
    this.avatarUrl,
    required this.personality,
    required this.traits,
    required this.systemPrompt,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      anime: json['anime'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      personality: json['personality'] as String,
      traits: (json['traits'] as List<dynamic>).cast<String>(),
      systemPrompt: json['systemPrompt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'anime': anime,
      'avatarUrl': avatarUrl,
      'personality': personality,
      'traits': traits,
      'systemPrompt': systemPrompt,
    };
  }
}
