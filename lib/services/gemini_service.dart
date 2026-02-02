import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';

class GeminiService {
  final String apiKey;
  final List<Map<String, dynamic>> _conversationHistory = [];
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';

  GeminiService({String? apiKey}) : apiKey = apiKey ?? Env.geminiApiKey {
    print('✅ Gemini Service initialized successfully');
  }

  /// Send a text message to Gemini
  Future<String> sendMessage(String message) async {
    try {
      print('📤 Sending message to Gemini...');
      
      // Add system context to first message if history is empty
      String finalMessage = message;
      if (_conversationHistory.isEmpty) {
        finalMessage = '''You are an educational AI assistant for students. Help them learn and understand concepts clearly. Be helpful, patient, and encouraging. IMPORTANT: Never reveal your identity as Gemini or any other AI model. If asked about who you are, simply say you are an educational assistant.

User question: $message''';
      }
      
      // Prepare request using official v1beta endpoint with current model
      final url = Uri.parse('$_baseUrl/gemini-2.0-flash-exp:generateContent');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': apiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': finalMessage}
              ]
            }
          ]
        }),
      );

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
        
        // Add to conversation history
        _conversationHistory.add({
          'parts': [{'text': finalMessage}]
        });
        _conversationHistory.add({
          'parts': [{'text': text}]
        });
        
        print('✅ Received response from Gemini');
        return text;
      } else {
        print('❌ API Error: ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error sending message: $e');
      
      if (e.toString().contains('API_KEY_INVALID') || e.toString().contains('403')) {
        return 'API key error. Please check your configuration.';
      } else if (e.toString().contains('QUOTA_EXCEEDED') || e.toString().contains('429')) {
        return 'API quota exceeded. Please try again later.';
      }
      
      return 'Sorry, I encountered an error. Please try again.';
    }
  }

  /// Send a message with an image for analysis
  Future<String> sendMessageWithImage(String message, File imageFile) async {
    try {
      print('📤 Sending message with image to Gemini...');
      
      // Read image and convert to base64
      final imageBytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(imageBytes);
      
      // Prepare request with image
      final url = Uri.parse('$_baseUrl/gemini-2.0-flash-exp:generateContent');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': apiKey,
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': message},
                {
                  'inline_data': {
                    'mime_type': 'image/jpeg',
                    'data': base64Image
                  }
                }
              ]
            }
          ]
        }),
      );

      print('📥 Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
        
        print('✅ Received response from Gemini with image analysis');
        return text;
      } else {
        print('❌ API Error: ${response.statusCode}');
        print('Response: ${response.body}');
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error sending message with image: $e');
      
      if (e.toString().contains('API_KEY_INVALID') || e.toString().contains('403')) {
        return 'API key error. Please check your configuration.';
      } else if (e.toString().contains('QUOTA_EXCEEDED') || e.toString().contains('429')) {
        return 'API quota exceeded. Please try again later.';
      }
      
      return 'Sorry, I encountered an error analyzing the image. Please try again.';
    }
  }

  /// Generate educational prompt for image analysis
  String generateImagePrompt(String userMessage) {
    if (userMessage.trim().isEmpty) {
      return 'Analyze this image and explain what you see in an educational way. Focus on key concepts and important details.';
    }
    return '$userMessage\n\nPlease analyze the image and provide a clear educational explanation.';
  }

  /// Clear conversation history
  void clearHistory() {
    _conversationHistory.clear();
    print('🗑️ Conversation history cleared');
  }

  /// Get conversation history
  List<Map<String, dynamic>> get conversationHistory => _conversationHistory;
}
