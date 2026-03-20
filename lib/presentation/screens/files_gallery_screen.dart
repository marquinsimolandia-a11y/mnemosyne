import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../providers/files_provider.dart';
import '../widgets/glass_card.dart';

class FilesGalleryScreen extends ConsumerWidget {
  const FilesGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filesState = ref.watch(filesProvider);
    final filesNotifier = ref.read(filesProvider.notifier);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'GALERIA DE ARQUIVOS',
          style: GoogleFonts.orbitron(
            fontSize: 16,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
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
              
              // Filter Chips (Placeholder for Sci-Fi look)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFilterChip('TODOS', true),
                    _buildFilterChip('IMAGENS', false),
                    _buildFilterChip('DOCUMENTOS', false),
                    _buildFilterChip('CAD/3D', false),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Files Grid
              Expanded(
                child: filesState.galleryFiles.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: filesState.galleryFiles.length,
                      itemBuilder: (context, index) {
                        final file = filesState.galleryFiles[index];
                        final fileName = file.path.split('/').last;
                        final extension = fileName.split('.').last.toLowerCase();

                        return GlassCard(
                          padding: EdgeInsets.zero,
                          borderRadius: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // File Preview Placeholder
                              Expanded(
                                flex: 3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  ),
                                  child: Icon(
                                    _getFileIcon(extension),
                                    size: 40,
                                    color: AppTheme.neonCyan.withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                              // File Info
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fileName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.exo2(
                                          color: AppTheme.textPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            extension.toUpperCase(),
                                            style: TextStyle(
                                              color: AppTheme.neonCyan.withValues(alpha: 0.7),
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => filesNotifier.openFile(file.path),
                                            child: const Icon(
                                              LucideIcons.download,
                                              size: 16,
                                              color: AppTheme.neonCyan,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ).animate()
                         .fadeIn(delay: (index * 100).ms)
                         .scale(begin: const Offset(0.9, 0.9));
                      },
                    ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final path = await filesNotifier.pickFile();
          if (path != null) {
            filesNotifier.addToGallery(path);
          }
        },
        backgroundColor: AppTheme.surfaceDark,
        elevation: 10,
        shape: const CircleBorder(side: BorderSide(color: AppTheme.neonCyan, width: 2)),
        child: const Icon(LucideIcons.plus, color: AppTheme.neonCyan),
      ).animate()
       .scale(delay: 500.ms),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.neonCyan.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppTheme.neonCyan : AppTheme.glassCardBorder,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.orbitron(
          color: isSelected ? AppTheme.neonCyan : AppTheme.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.folderX, size: 64, color: AppTheme.textSecondary.withValues(alpha: 0.3)),
          const SizedBox(height: 20),
          Text(
            'NENHUM ARQUIVO GERADO AINDA',
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

  IconData _getFileIcon(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'webp':
        return LucideIcons.image;
      case 'pdf':
        return LucideIcons.fileText;
      case 'dwg':
      case 'dxf':
        return LucideIcons.layers;
      case 'mp3':
      case 'wav':
        return LucideIcons.music;
      default:
        return LucideIcons.file;
    }
  }
}
