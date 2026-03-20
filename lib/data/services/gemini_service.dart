import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../core/constants/app_constants.dart';
import 'dart:developer' as dev;

class GeminiService {
  final GenerativeModel _model;
  ChatSession? _chatSession;

  GeminiService()
      : _model = GenerativeModel(
          model: 'gemini-1.5-pro',
          apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
          systemInstruction: Content.system(kSystemPrompt),
        );

  /// Initializes a chat session with history.
  /// Note: The actual history injection will happen in the ChatViewModel 
  /// by reloading from the database and calling this.
  void startNewSession({List<Content>? history}) {
    _chatSession = _model.startChat(history: history);
  }

  /// Sends a message to Gemini and returns the response.
  Future<String?> sendMessage(String text, {List<DataPart>? attachments}) async {
    try {
      if (_chatSession == null) {
        startNewSession();
      }

      final content = Content.multi([
        TextPart(text),
        if (attachments != null) ...attachments,
      ]);

      final response = await _chatSession!.sendMessage(content);
      return response.text;
    } catch (e) {
      dev.log('Gemini API Error: $e');
      return 'Erro na conexão com Mnemosyne: $e';
    }
  }
}
