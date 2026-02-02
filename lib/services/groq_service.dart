import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';

class GroqService {
  final String apiKey;
  final List<Map<String, dynamic>> _conversationHistory = [];
  static const String _baseUrl = 'https://api.groq.com/openai/v1';

  GroqService({String? apiKey}) : apiKey = apiKey ?? Env.groqApiKey {
    // Add system message to conversation history
    _conversationHistory.add({
      'role': 'system',
      'content': 'You are an educational AI assistant for students. Help them learn and understand concepts clearly. '
          'Be helpful, patient, and encouraging. IMPORTANT: Never reveal your identity or what AI model you are. '
          'If asked about who you are, simply say you are an educational assistant designed to help students learn.'
    });
    print('✅ Groq Service initialized successfully');
  }

  /// Send a text message to Groq
  Future<String> sendMessage(String message) async {
    try {
      print('📤 Sending message to Groq...');
      
      // Add user message to history
      _conversationHistory.add({
        'role': 'user',
        'content': message
      });
      
      // Prepare request
      final url = Uri.parse('$_baseUrl/chat/completions');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'llama-3.3-70b-versatile',  // Fast and capable model
          'messages': _conversationHistory,
          'temperature': 0.7,
          'max_tokens': 2000,
        }),
      );

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['choices'][0]['message']['content'] as String;
        
        // Add assistant response to history
        _conversationHistory.add({
          'role': 'assistant',
          'content': text
        });
        
        print('✅ Received response from Groq');
        return text;
      } else {
        print('❌ API Error: ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error sending message: $e');
      
      if (e.toString().contains('401') || e.toString().contains('403')) {
        return 'API key error. Please get a free API key from https://console.groq.com';
      } else if (e.toString().contains('429')) {
        return 'Rate limit exceeded. Please try again in a moment.';
      }
      
      return 'Sorry, I encountered an error. Please try again.';
    }
  }

  /// Send a message with an image for analysis using Llama Vision
  Future<String> sendMessageWithImage(String message, String imagePath) async {
    try {
      print('📤 Sending message with image to Groq Vision...');
      
      // Read image bytes (works on both web and mobile)
      final imageBytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(imageBytes);
      
      // Prepare request with vision model
      final url = Uri.parse('$_baseUrl/chat/completions');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'llama-4-scout-17b-16e-instruct',  // Llama 4 vision model (current)
          'messages': [
            {
              'role': 'user',
              'content': [
                {
                  'type': 'text',
                  'text': message.isEmpty ? 'ما هو محتوى هذه الصورة؟ اشرح بالتفصيل.' : message
                },
                {
                  'type': 'image_url',
                  'image_url': {
                    'url': 'data:image/jpeg;base64,$base64Image'
                  }
                }
              ]
            }
          ],
          'temperature': 0.7,
          'max_tokens': 2000,
        }),
      );

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['choices'][0]['message']['content'] as String;
        
        print('✅ Received response from Groq Vision');
        return text;
      } else {
        print('❌ API Error: ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error sending message with image: $e');
      
      if (e.toString().contains('401') || e.toString().contains('403')) {
        return 'API key error. Please check your Groq API key.';
      } else if (e.toString().contains('429')) {
        return 'Rate limit exceeded. Please try again in a moment.';
      }
      
      return 'Sorry, I encountered an error analyzing the image. Please try again.';
    }
  }

  /// Clear conversation history (keep system message)
  void clearHistory() {
    final systemMessage = _conversationHistory.first;
    _conversationHistory.clear();
    _conversationHistory.add(systemMessage);
    print('🗑️ Conversation history cleared');
  }

  /// Get conversation history
  List<Map<String, dynamic>> get conversationHistory => _conversationHistory;
}
