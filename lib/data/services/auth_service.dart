import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/auth_user_model.dart';

/// Authentication Service
class AuthService {
  static const String _authBoxName = 'auth';
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  /// Initialize auth service
  static Future<void> init() async {
    await Hive.openBox(_authBoxName);
  }

  /// Check if user is logged in
  static bool isLoggedIn() {
    final box = Hive.box(_authBoxName);
    return box.get(_isLoggedInKey, defaultValue: false);
  }

  /// Get current user
  static AuthUserModel? getCurrentUser() {
    if (!isLoggedIn()) return null;
    
    final box = Hive.box(_authBoxName);
    final userJson = box.get(_userKey);
    
    if (userJson == null) return null;
    
    return AuthUserModel.fromJson(Map<String, dynamic>.from(userJson));
  }

  /// Register new user
  static Future<AuthUserModel> register({
    required String email,
    required String username,
    required String password,
  }) async {
    final box = Hive.box(_authBoxName);
    
    // Create new user
    final user = AuthUserModel(
      id: const Uuid().v4(),
      email: email,
      username: username,
      createdAt: DateTime.now(),
      isVerified: true, // Auto-verify for now
    );
    
    // Save user
    await box.put(_userKey, user.toJson());
    await box.put(_isLoggedInKey, true);
    
    return user;
  }

  /// Login user
  static Future<AuthUserModel> login({
    required String email,
    required String password,
  }) async {
    final box = Hive.box(_authBoxName);
    
    // For demo, just check if user exists
    final existingUserJson = box.get(_userKey);
    
    if (existingUserJson != null) {
      final user = AuthUserModel.fromJson(Map<String, dynamic>.from(existingUserJson));
      await box.put(_isLoggedInKey, true);
      return user;
    }
    
    // Create new user if doesn't exist
    return await register(email: email, username: email.split('@')[0], password: password);
  }

  /// Logout user
  static Future<void> logout() async {
    final box = Hive.box(_authBoxName);
    await box.put(_isLoggedInKey, false);
  }

  /// Update user profile
  static Future<void> updateProfile({
    String? username,
    String? avatarUrl,
  }) async {
    final user = getCurrentUser();
    if (user == null) return;
    
    final updatedUser = user.copyWith(
      username: username,
      avatarUrl: avatarUrl,
    );
    
    final box = Hive.box(_authBoxName);
    await box.put(_userKey, updatedUser.toJson());
  }

  /// Delete account
  static Future<void> deleteAccount() async {
    final box = Hive.box(_authBoxName);
    await box.delete(_userKey);
    await box.put(_isLoggedInKey, false);
  }
}
