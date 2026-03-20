import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../providers/voice_provider.dart';
import '../providers/chat_provider.dart';

class VoiceInterfaceScreen extends ConsumerStatefulWidget {
  const VoiceInterfaceScreen({super.key});

  @override
  ConsumerState<VoiceInterfaceScreen> createState() => _VoiceInterfaceScreenState();
}

class _VoiceInterfaceScreenState extends ConsumerState<VoiceInterfaceScreen> with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Start listening automatically when entering the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(voiceProvider.notifier).startListening();
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceProvider);
    final voiceNotifier = ref.read(voiceProvider.notifier);
    final chatNotifier = ref.read(chatProvider.notifier);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(LucideIcons.x, color: AppTheme.neonCyan),
                      onPressed: () {
                        voiceNotifier.stopListening();
                        context.pop();
                      },
                    ),
                    Text(
                      'INTERFACE DE VOZ',
                      style: GoogleFonts.orbitron(
                        color: AppTheme.neonCyan,
                        fontSize: 14,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 48), // Spacer
                  ],
                ),
              ),

              const Spacer(),

              // Animated Waveform Visualizer
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer pulsating rings
                    ...List.generate(3, (index) {
                      return Container(
                        width: 200 + (index * 40),
                        height: 200 + (index * 40),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.neonCyan.withValues(alpha: 0.1),
                            width: 1,
                          ),
                        ),
                      ).animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(
                          begin: const Offset(1, 1),
                          end: Offset(1.1 + (index * 0.05), 1.1 + (index * 0.05)),
                          duration: (2 + index).seconds,
                          curve: Curves.easeInOut,
                        );
                    }),
                    
                    // The Waveform
                    AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: WaveformPainter(
                            animationValue: _waveController.value,
                            soundLevel: voiceState.soundLevel,
                            color: AppTheme.neonCyan,
                          ),
                          size: const Size(200, 200),
                        );
                      },
                    ),

                    // Central Mic Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.surfaceDark,
                        border: Border.all(color: AppTheme.neonCyan, width: 2),
                        boxShadow: AppTheme.cyanGlow(blurRadius: 20),
                      ),
                      child: Icon(
                        voiceState.isListening ? LucideIcons.mic : LucideIcons.micOff,
                        color: AppTheme.neonCyan,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Recognized Text Area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: Text(
                    voiceState.words.isEmpty 
                      ? (voiceState.isListening ? 'Ouvindo...' : 'Interface Pronta')
                      : voiceState.words.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.orbitron(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      letterSpacing: 1,
                      shadows: [
                        if (voiceState.words.isNotEmpty)
                          Shadow(color: AppTheme.neonCyan.withValues(alpha: 0.5), blurRadius: 10),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Action Button
                  GestureDetector(
                    onTap: () {
                      if (voiceState.isListening) {
                        voiceNotifier.stopListening();
                        if (voiceState.words.isNotEmpty) {
                          chatNotifier.sendMessage(voiceState.words);
                          context.pop();
                        }
                      } else {
                        voiceNotifier.startListening();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: voiceState.isListening ? AppTheme.neonCyan.withValues(alpha: 0.1) : AppTheme.neonPurple.withValues(alpha: 0.1),
                        border: Border.all(
                          color: voiceState.isListening ? AppTheme.neonCyan : AppTheme.neonPurple,
                          width: 2,
                        ),
                        boxShadow: voiceState.isListening 
                          ? AppTheme.cyanGlow(blurRadius: 15)
                          : AppTheme.purpleGlow(blurRadius: 15),
                      ),
                      child: Icon(
                        voiceState.isListening ? LucideIcons.check : LucideIcons.play,
                        color: voiceState.isListening ? AppTheme.neonCyan : AppTheme.neonPurple,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class WaveformPainter extends CustomPainter {
  final double animationValue;
  final double soundLevel;
  final Color color;

  WaveformPainter({
    required this.animationValue,
    required this.soundLevel,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    // Draw multiple sine-like waves in a circle
    for (int j = 0; j < 3; j++) {
      final path = Path();
      const int points = 100;
      final waveIntensity = 5 + (soundLevel * 15);
      
      for (int i = 0; i <= points; i++) {
        final angle = (i / points) * 2 * pi;
        final distortion = sin(angle * 8 + (animationValue * 2 * pi) + (j * pi / 2)) * waveIntensity;
        final currentRadius = radius + distortion;
        
        final x = center.dx + currentRadius * cos(angle);
        final y = center.dy + currentRadius * sin(angle);
        
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint..color = color.withValues(alpha: 0.2 + (j * 0.2)));
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.soundLevel != soundLevel;
  }
}
