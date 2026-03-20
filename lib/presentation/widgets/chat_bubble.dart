import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/glass_card.dart';
import '../../data/models/message_model.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ChatBubble extends StatelessWidget {
  final MessageModel message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == MessageRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              _buildMnemosyneAvatar(),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: GlassCard(
                borderRadius: 16,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                borderColor: isUser 
                  ? AppTheme.neonCyan.withValues(alpha: 0.3) 
                  : AppTheme.neonPurple.withValues(alpha: 0.3),
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
  }

  Widget _buildMnemosyneAvatar() {
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
}
