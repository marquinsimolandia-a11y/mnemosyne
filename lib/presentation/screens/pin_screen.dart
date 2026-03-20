import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../providers/pin_provider.dart';

class PinScreen extends ConsumerWidget {
  const PinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pinProvider);
    final notifier = ref.read(pinProvider.notifier);

    // Listen for authentication success
    ref.listen(pinProvider, (previous, next) {
      if (next.isAuthenticated) {
        context.go('/chat');
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Security Header
              const Icon(
                Icons.security_rounded,
                size: 48,
                color: AppTheme.neonCyan,
              ).animate()
                .fadeIn(duration: 800.ms)
                .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
              
              const SizedBox(height: 20),
              
              Text(
                'ACESSO RESTRITO',
                style: GoogleFonts.orbitron(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.neonCyan,
                  letterSpacing: 2,
                ),
              ),
              
              Text(
                'INSIRA O CÓDIGO DE ACESSO',
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  letterSpacing: 2,
                ),
              ),
              
              const SizedBox(height: 50),
              
              // PIN Dots Container
              Container(
                height: 80,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    bool isActive = state.pin.length > index;
                    return Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isActive ? AppTheme.neonCyan : Colors.transparent,
                        border: Border.all(color: AppTheme.neonCyan, width: 2),
                        boxShadow: isActive ? AppTheme.cyanGlow(blurRadius: 15) : null,
                      ),
                    ).animate(target: isActive ? 1 : 0)
                     .scale(end: const Offset(1.2, 1.2), duration: 200.ms);
                  }),
                ),
              ).animate(target: state.isError ? 1 : 0)
               .shakeX(duration: 500.ms, hz: 10)
               .callback(callback: (_) => notifier.resetError()),

              const SizedBox(height: 40),
              
              // Keypad
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ...List.generate(9, (index) => _buildKey(context, notifier, index + 1)),
                      const SizedBox.shrink(),
                      _buildKey(context, notifier, 0),
                      IconButton(
                        icon: const Icon(Icons.backspace_rounded, color: AppTheme.neonPurple),
                        onPressed: () => notifier.removeDigit(),
                      ).animate()
                       .fadeIn(delay: 500.ms),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKey(BuildContext context, PinViewModel notifier, int digit) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          notifier.addDigit(digit);
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.glassCard,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.glassCardBorder),
          ),
          alignment: Alignment.center,
          child: Text(
            digit.toString(),
            style: GoogleFonts.orbitron(
              fontSize: 24,
              color: AppTheme.neonCyan,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ).animate()
     .fadeIn(delay: Duration(milliseconds: 100 * (digit == 0 ? 10 : digit)))
     .scale(begin: const Offset(0.8, 0.8));
  }
}
