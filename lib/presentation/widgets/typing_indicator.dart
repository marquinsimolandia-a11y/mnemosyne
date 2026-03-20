import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';

class TypingIndicator extends StatelessWidget {
  const TypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: const BoxDecoration(
            color: AppTheme.neonPurple,
            shape: BoxShape.circle,
          ),
        ).animate(onPlay: (controller) => controller.repeat())
         .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.5, 1.5),
            duration: 600.ms,
            delay: (index * 200).ms,
            curve: Curves.easeInOut,
          )
         .then()
         .scale(
            begin: const Offset(1.5, 1.5),
            end: const Offset(1, 1),
            duration: 600.ms,
          );
      }),
    );
  }
}
