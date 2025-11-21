/// User Model
class UserModel {
  final String id;
  final String username;
  final String? avatarUrl;
  final String? bio;
  final String? openRouterApiKey;
  final String? githubToken;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    this.avatarUrl,
    this.bio,
    this.openRouterApiKey,
    this.githubToken,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String?,
      openRouterApiKey: json['openRouterApiKey'] as String?,
      githubToken: json['githubToken'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatarUrl': avatarUrl,
      'bio': bio,
      'openRouterApiKey': openRouterApiKey,
      'githubToken': githubToken,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? username,
    String? avatarUrl,
    String? bio,
    String? openRouterApiKey,
    String? githubToken,
  }) {
    return UserModel(
      id: id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      openRouterApiKey: openRouterApiKey ?? this.openRouterApiKey,
      githubToken: githubToken ?? this.githubToken,
      createdAt: createdAt,
    );
  }
}
