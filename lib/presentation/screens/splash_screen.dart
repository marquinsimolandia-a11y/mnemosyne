import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 4));
    if (mounted) {
      context.go('/pin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Animation
            Stack(
              alignment: Alignment.center,
              children: [
                // Outer Glow
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.cyanGlow(blurRadius: 40),
                  ),
                ).animate(onPlay: (controller) => controller.repeat())
                  .scale(begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2), duration: 2.seconds, curve: Curves.easeInOut)
                  .then()
                  .scale(begin: const Offset(1.2, 1.2), end: const Offset(0.8, 0.8), duration: 2.seconds, curve: Curves.easeInOut),
                
                // Core Icon
                const Icon(
                  Icons.memory_rounded,
                  size: 80,
                  color: AppTheme.neonCyan,
                ).animate()
                  .fadeIn(duration: 1.seconds)
                  .scale(begin: const Offset(0.5, 0.5), end: const Offset(1.0, 1.0), curve: Curves.elasticOut, duration: 1.5.seconds)
                  .shimmer(delay: 2.seconds, duration: 2.seconds, color: AppTheme.neonPurple),
              ],
            ),
            const SizedBox(height: 40),
            // App Name
            Text(
              'MNEMOSYNE',
              style: GoogleFonts.orbitron(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppTheme.neonCyan,
                letterSpacing: 8,
                shadows: const [
                  Shadow(color: AppTheme.neonCyan, blurRadius: 10),
                  Shadow(color: AppTheme.neonPurple, blurRadius: 20),
                ],
              ),
            ).animate()
             .fadeIn(delay: 500.ms, duration: 1.seconds)
             .slideY(begin: 0.5, end: 0.0, curve: Curves.easeOut),
            
            const SizedBox(height: 10),
            // Tagline
            Text(
              'GODDESS OF MEMORY',
              style: GoogleFonts.orbitron(
                fontSize: 10,
                color: AppTheme.textSecondary,
                letterSpacing: 4,
              ),
            ).animate()
             .fadeIn(delay: 1.5.seconds, duration: 1.seconds),
          ],
        ),
      ),
    );
  }
}
