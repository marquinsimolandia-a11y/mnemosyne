import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/message_model.dart';
import '../../data/database/message_dao.dart';
import '../../data/services/gemini_service.dart';
import '../../core/constants/app_constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:uuid/uuid.dart';

class ChatState {
  final List<MessageModel> messages;
  final bool isLoading;
  final String? error;

  ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<MessageModel>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ChatViewModel extends StateNotifier<ChatState> {
  final MessageDao _messageDao;
  final GeminiService _geminiService;
  final Uuid _uuid = const Uuid();

  ChatViewModel(this._messageDao, this._geminiService) : super(ChatState()) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    state = state.copyWith(isLoading: true);
    try {
      final history = await _messageDao.getLastMessages(kHistoryLimit);
      
      final geminiHistory = history.map((m) {
        return m.role == MessageRole.user
            ? Content.text(m.content)
            : Content.model([TextPart(m.content)]);
      }).toList();

      _geminiService.startNewSession(history: geminiHistory);
      
      state = state.copyWith(messages: history, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> sendMessage(String text, {List<String>? attachmentPaths}) async {
    if (text.trim().isEmpty && (attachmentPaths == null || attachmentPaths.isEmpty)) return;

    final userMessage = MessageModel(
      id: _uuid.v4(),
      content: text,
      role: MessageRole.user,
      timestamp: DateTime.now(),
      attachments: attachmentPaths,
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    try {
      await _messageDao.insertMessage(userMessage);

      final response = await _geminiService.sendMessage(text);

      if (response != null) {
        final mnoMessage = MessageModel(
          id: _uuid.v4(),
          content: response,
          role: MessageRole.model,
          timestamp: DateTime.now(),
        );

        await _messageDao.insertMessage(mnoMessage);
        state = state.copyWith(
          messages: [...state.messages, mnoMessage],
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> clearChat() async {
    await _messageDao.clearHistory();
    _geminiService.startNewSession(history: []);
    state = ChatState();
  }
}
