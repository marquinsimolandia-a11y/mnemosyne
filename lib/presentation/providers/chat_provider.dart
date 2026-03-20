import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/chat_viewmodel.dart';
import '../../data/database/message_dao.dart';
import '../../data/services/gemini_service.dart';

final messageDaoProvider = Provider((ref) => MessageDao());
final geminiServiceProvider = Provider((ref) => GeminiService());

final chatProvider = StateNotifierProvider<ChatViewModel, ChatState>((ref) {
  final dao = ref.watch(messageDaoProvider);
  final gemini = ref.watch(geminiServiceProvider);
  return ChatViewModel(dao, gemini);
});
