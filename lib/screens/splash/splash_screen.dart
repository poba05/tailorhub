import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tailorhub/screens/onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _progressController;
  late final Animation<double> _entranceAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2300),
    )..forward();
    _entranceAnimation = CurvedAnimation(
      parent: _progressController,
      curve: const Interval(0, .38, curve: Curves.easeOutCubic),
    );
    _navigationTimer = Timer(
      const Duration(milliseconds: 2700),
      _openOnboarding,
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  void _openOnboarding() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const OnboardingScreen(),
        transitionDuration: const Duration(milliseconds: 420),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF210D32),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, .02),
            radius: 1.12,
            colors: [Color(0xFF64217F), Color(0xFF40145C), Color(0xFF210D32)],
            stops: [0, .52, 1],
          ),
        ),
        child: SizedBox.expand(
          child: Center(
            child: FadeTransition(
              opacity: _entranceAnimation,
              child: AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, 5 * (1 - _entranceAnimation.value)),
                  child: child,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 78,
                      height: 78,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .035),
                        borderRadius: BorderRadius.circular(21),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .22),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFFE733A7,
                            ).withValues(alpha: .12),
                            blurRadius: 34,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.content_cut_rounded,
                        size: 29,
                        color: Color(0xFFF4D9F2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'TailorHub',
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 36,
                        height: 1,
                        fontVariations: [FontVariation('wght', 600)],
                        letterSpacing: -.35,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'THE ATELIER WORKBOOK',
                      style: TextStyle(
                        fontFamily: 'DMSANS',
                        fontSize: 8,
                        fontVariations: [FontVariation('wght', 600)],
                        letterSpacing: 2.6,
                        color: Color(0xFFD9C3DF),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: 136,
                      height: 2,
                      child: AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) => ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _progressController.value,
                            backgroundColor: Colors.white.withValues(
                              alpha: .13,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFE83BA7),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
