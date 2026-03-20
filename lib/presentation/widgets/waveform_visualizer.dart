import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class WaveformVisualizer extends StatefulWidget {
  final double soundLevel;
  final Color color;
  final double size;

  const WaveformVisualizer({
    super.key,
    required this.soundLevel,
    this.color = AppTheme.neonCyan,
    this.size = 200,
  });

  @override
  State<WaveformVisualizer> createState() => _WaveformVisualizerState();
}

class _WaveformVisualizerState extends State<WaveformVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _WaveformPainter(
            animationValue: _controller.value,
            soundLevel: widget.soundLevel,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final double animationValue;
  final double soundLevel;
  final Color color;

  _WaveformPainter({
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
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.soundLevel != soundLevel;
  }
}
