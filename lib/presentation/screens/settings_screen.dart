import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../providers/settings_provider.dart';
import '../widgets/glass_card.dart';
import '../widgets/neon_button.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('P&D E CONFIGURAÇÕES'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppTheme.neonCyan),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // Header description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  borderRadius: 16,
                  child: Row(
                    children: [
                      const Icon(LucideIcons.cpu, color: AppTheme.neonGreen, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AUTO-APRIMORAMENTO',
                              style: GoogleFonts.orbitron(
                                color: AppTheme.neonGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Gerencie diretrizes e parâmetros de evolução da Mnemosyne.',
                              style: GoogleFonts.exo2(
                                color: AppTheme.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Instructions List
              Expanded(
                child: settingsState.instructions.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: settingsState.instructions.length,
                      itemBuilder: (context, index) {
                        final instruction = settingsState.instructions[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: GlassCard(
                            padding: const EdgeInsets.all(16),
                            borderRadius: 16,
                            borderColor: AppTheme.neonGreen.withValues(alpha: 0.2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        instruction.title.toUpperCase(),
                                        style: GoogleFonts.orbitron(
                                          color: AppTheme.neonCyan,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(LucideIcons.trash2, size: 18, color: AppTheme.error),
                                      onPressed: () => settingsNotifier.deleteInstruction(instruction.id),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  instruction.content,
                                  style: GoogleFonts.exo2(
                                    color: AppTheme.textPrimary,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'CRIADO EM: ${instruction.createdAt.day}/${instruction.createdAt.month}/${instruction.createdAt.year}',
                                  style: GoogleFonts.orbitron(
                                    color: AppTheme.textSecondary,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              ),

              // Add Button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: NeonButton(
                  label: 'ADICIONAR DIRETRIZ',
                  icon: LucideIcons.plus,
                  color: AppTheme.neonGreen,
                  onPressed: () => _showAddInstructionDialog(context, settingsNotifier),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.terminal, size: 64, color: AppTheme.textSecondary.withValues(alpha: 0.2)),
          const SizedBox(height: 20),
          Text(
            'NENHUMA DIRETRIZ DE P&D',
            style: GoogleFonts.orbitron(
              color: AppTheme.textSecondary.withValues(alpha: 0.5),
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddInstructionDialog(BuildContext context, SettingsViewModel notifier) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppTheme.neonCyan, width: 1.5),
        ),
        title: Text(
          'NOVA DIRETRIZ',
          style: GoogleFonts.orbitron(color: AppTheme.neonCyan, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(hintText: 'Título do Módulo'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              maxLines: 3,
              style: const TextStyle(color: AppTheme.textPrimary),
              decoration: const InputDecoration(hintText: 'Conteúdo da Instrução'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('CANCELAR', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
                notifier.addInstruction(titleController.text, contentController.text);
                context.pop();
              }
            },
            child: const Text('SALVAR', style: TextStyle(color: AppTheme.neonGreen)),
          ),
        ],
      ),
    );
  }
}
