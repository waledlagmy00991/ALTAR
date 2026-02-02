import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/chat_message.dart';
import '../services/groq_service.dart';
import '../services/camera_service.dart';

class ChatProvider extends ChangeNotifier {
  final GroqService _groqService = GroqService();
  final CameraService _cameraService = CameraService();
  
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  XFile? _selectedImage;

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  XFile? get selectedImage => _selectedImage;

  /// Send a text message
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty && _selectedImage == null) return;

    // Create user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: text,
      isUser: true,
      imageUrl: _selectedImage?.path,
    );

    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    // Clear selected image after sending
    final hasImage = _selectedImage != null;
    _selectedImage = null;

    try {
      // Get AI response
      String aiResponse;
      
      if (hasImage) {
        // Use Groq Vision for image analysis
        aiResponse = await _groqService.sendMessageWithImage(text, userMessage.imageUrl!);
      } else {
        // Use Groq for text-only messages
        aiResponse = await _groqService.sendMessage(text);
      }

      // Add AI message
      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: aiResponse,
        isUser: false,
      );

      _messages.add(aiMessage);
    } catch (e) {
      // Add error message
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Sorry, I encountered an error. Please try again.',
        isUser: false,
      );
      _messages.add(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Capture image from camera
  Future<void> captureImage() async {
    final image = await _cameraService.captureImage();
    if (image != null) {
      _selectedImage = image;
      notifyListeners();
    }
  }

  /// Pick image from gallery
  Future<void> pickImageFromGallery() async {
    final image = await _cameraService.pickImageFromGallery();
    if (image != null) {
      _selectedImage = image;  // Store XFile object
      notifyListeners();
    }
  }

  /// Clear selected image
  void clearSelectedImage() {
    _selectedImage = null;
    notifyListeners();
  }

  /// Clear all messages
  void clearMessages() {
    _messages.clear();
    _groqService.clearHistory();
    notifyListeners();
  }
}
