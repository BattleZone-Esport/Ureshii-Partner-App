import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../core/constants/api_config.dart';

/// OpenRouter AI Service for URESHII Partner
class OpenRouterService {
  final Dio _dio;

  OpenRouterService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.openRouterBaseUrl,
            headers: {
              'Authorization': 'Bearer ${ApiConfig.openRouterApiKey}',
              'HTTP-Referer': 'https://ureshii-partner.app',
              'X-Title': 'URESHII Partner',
              'Content-Type': 'application/json',
            },
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 60),
            validateStatus: (status) {
              return status != null && status < 500;
            },
          ),
        );

  /// Generate code using Ureshii AI
  Future<String> generateCode(String prompt) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': ApiConfig.codingModel,
          'messages': [
            {
              'role': 'system',
              'content': ApiConfig.secretSystemPrompt,
            },
            {
              'role': 'user',
              'content': prompt,
            },
          ],
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data['choices'][0]['message']['content'];
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Generate code error: $e');
      }
      rethrow;
    }
  }

  /// Chat with character (roleplay mode)
  Future<String> chatWithCharacter({
    required String characterPrompt,
    required String message,
    List<Map<String, String>>? chatHistory,
  }) async {
    try {
      final messages = [
        {
          'role': 'system',
          'content': '${ApiConfig.secretSystemPrompt}\n\n$characterPrompt',
        },
        if (chatHistory != null) ...chatHistory,
        {
          'role': 'user',
          'content': message,
        },
      ];

      if (kDebugMode) {
        debugPrint('🚀 OpenRouter Request:');
        debugPrint('   URL: ${ApiConfig.openRouterBaseUrl}/chat/completions');
        debugPrint('   Model: ${ApiConfig.roleplayModel}');
        debugPrint('   Message: $message');
      }

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': ApiConfig.roleplayModel,
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 500,
        },
      );

      if (kDebugMode) {
        debugPrint('✅ Response: ${response.statusCode}');
      }

      if (response.statusCode == 200 && response.data != null) {
        final content = response.data['choices'][0]['message']['content'];
        return content ?? 'No response generated';
      } else {
        throw Exception('API returned status ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Chat error: $e');
      }
      rethrow;
    }
  }

  /// General chat with Ureshii AI
  Future<String> chat({
    required String message,
    List<Map<String, String>>? chatHistory,
  }) async {
    try {
      final messages = [
        {
          'role': 'system',
          'content': ApiConfig.secretSystemPrompt,
        },
        if (chatHistory != null) ...chatHistory,
        {
          'role': 'user',
          'content': message,
        },
      ];

      if (kDebugMode) {
        debugPrint('🚀 OpenRouter Chat Request:');
        debugPrint('   URL: ${ApiConfig.openRouterBaseUrl}/chat/completions');
        debugPrint('   Model: ${ApiConfig.chatModel}');
      }

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': ApiConfig.chatModel,
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 500,
        },
      );

      if (kDebugMode) {
        debugPrint('✅ Chat Response: ${response.statusCode}');
      }

      if (response.statusCode == 200 && response.data != null) {
        final content = response.data['choices'][0]['message']['content'];
        return content ?? 'No response generated';
      } else {
        throw Exception('API returned status ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Chat error: $e');
      }
      rethrow;
    }
  }

  /// Stream chat responses (for real-time typing effect)
  Stream<String> streamChat({
    required String message,
    String? characterPrompt,
    List<Map<String, String>>? chatHistory,
  }) async* {
    try {
      final messages = [
        {
          'role': 'system',
          'content': characterPrompt != null
              ? '${ApiConfig.secretSystemPrompt}\n\n$characterPrompt'
              : ApiConfig.secretSystemPrompt,
        },
        if (chatHistory != null) ...chatHistory,
        {
          'role': 'user',
          'content': message,
        },
      ];

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': characterPrompt != null
              ? ApiConfig.roleplayModel
              : ApiConfig.chatModel,
          'messages': messages,
          'stream': true,
        },
        options: Options(
          responseType: ResponseType.stream,
        ),
      );

      final stream = response.data.stream;
      await for (final chunk in stream) {
        final String chunkString = String.fromCharCodes(chunk);
        if (chunkString.contains('data: ')) {
          final lines = chunkString.split('\n');
          for (final line in lines) {
            if (line.startsWith('data: ') && !line.contains('[DONE]')) {
              try {
                final jsonStr = line.substring(6);
                yield jsonStr;
              } catch (_) {}
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Stream error: $e');
      }
      yield 'Error: Failed to connect to AI service';
    }
  }
}
