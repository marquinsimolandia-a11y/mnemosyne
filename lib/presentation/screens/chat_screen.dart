import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../providers/chat_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';
import '../viewmodels/chat_viewmodel.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final chatNotifier = ref.read(chatProvider.notifier);

    // Auto-scroll on new messages
    ref.listen(chatProvider, (prev, next) {
      if (prev?.messages.length != next.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('MNEMOSYNE'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings, color: AppTheme.neonCyan),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 40),
            // Chat Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: chatState.messages.length,
                itemBuilder: (context, index) {
                  final message = chatState.messages[index];
                  final isUser = message.role.name == 'user';
                  
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isUser) ...[
                            _buildAvatar(),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: GlassCard(
                              borderRadius: 16,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              borderColor: isUser ? AppTheme.neonCyan.withValues(alpha: 0.3) : AppTheme.neonPurple.withValues(alpha: 0.3),
                              child: Text(
                                message.content,
                                style: GoogleFonts.exo2(
                                  color: AppTheme.textPrimary,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          if (isUser) ...[
                            const SizedBox(width: 8),
                            _buildUserIndicator(),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            if (chatState.isLoading)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Mnemosyne processando...',
                  style: TextStyle(color: AppTheme.neonPurple, fontSize: 10, letterSpacing: 1),
                ),
              ),

            // Input Area
            _buildInputArea(chatNotifier),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildPAndDButton(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.neonPurple, width: 1.5),
        boxShadow: AppTheme.purpleGlow(blurRadius: 10),
      ),
      child: const Center(
        child: Icon(LucideIcons.bot, size: 18, color: AppTheme.neonPurple),
      ),
    );
  }

  Widget _buildUserIndicator() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppTheme.neonCyan, width: 1.5),
        boxShadow: AppTheme.cyanGlow(blurRadius: 10),
      ),
      child: const Center(
        child: Icon(LucideIcons.user, size: 18, color: AppTheme.neonCyan),
      ),
    );
  }

  Widget _buildInputArea(ChatViewModel notifier) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark.withValues(alpha: 0.8),
        border: Border(top: BorderSide(color: AppTheme.neonCyan.withValues(alpha: 0.2))),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(LucideIcons.paperclip, color: AppTheme.neonCyan),
            onPressed: () {
              // TODO: Implement file attachment logic
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Comando para Mnemosyne...',
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onSubmitted: (val) => _handleSendMessage(notifier),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(LucideIcons.send, color: AppTheme.neonCyan),
            onPressed: () => _handleSendMessage(notifier),
          ),
        ],
      ),
    );
  }

  void _handleSendMessage(ChatViewModel notifier) {
    if (_messageController.text.trim().isEmpty) return;
    notifier.sendMessage(_messageController.text);
    _messageController.clear();
  }

  Widget _buildPAndDButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FloatingActionButton(
        onPressed: () => context.push('/voice'),
        backgroundColor: AppTheme.surfaceDark,
        shape: const CircleBorder(side: BorderSide(color: AppTheme.neonCyan, width: 2)),
        elevation: 10,
        child: const Icon(LucideIcons.mic, color: AppTheme.neonCyan),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        border: Border(top: BorderSide(color: AppTheme.neonCyan.withValues(alpha: 0.2))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(LucideIcons.image, color: AppTheme.textSecondary),
            onPressed: () => context.push('/files'),
          ),
          NeonButton(
            label: 'P&D E AUTO-APRIMORAMENTO',
            color: AppTheme.neonGreen,
            onPressed: () {
              // TODO: Open self-improvement dialog
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.history, color: AppTheme.textSecondary),
            onPressed: () {
              // Placeholder for history toggle
            },
          ),
        ],
      ),
    );
  }
}
