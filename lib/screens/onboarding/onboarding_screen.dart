import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/models/onboarding.dart';
import 'package:tailorhub/screens/auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  int currentpage = 0;
  late final AnimationController _controller;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextpage() {
    if (currentpage < onboarding.length - 1) {
      setState(() => currentpage += 1);
      return;
    }
    _openLogin();
  }

  void _openLogin() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide = Tween<Offset>(
            begin: const Offset(0, 0.06),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(position: slide, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F1FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 8),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.025, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: _buildPage(key: ValueKey(currentpage)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() => Row(
    children: [
      Container(
        height: 38,
        width: 38,
        decoration: BoxDecoration(
          gradient: AppGradient.primaryGradient,
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Icon(Icons.content_cut_rounded, color: Colors.white, size: 21),
      ),
      const SizedBox(width: 10),
      Text(
        'TailorHub',
        style: TextStyle(
          fontFamily: 'DMSANS',
          fontSize: 17,
          fontVariations: const [FontVariation('wght', 700)],
          color: AppColor.text,
        ),
      ),
      const Spacer(),
      TextButton(
        onPressed: _openLogin,
        style: TextButton.styleFrom(
          foregroundColor: AppColor.first,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        ),
        child: Text('Skip', style: AppFonts.buttonText(color: AppColor.first)),
      ),
    ],
  );

  Widget _buildPage({required Key key}) {
    final page = onboarding[currentpage];
    return Column(
      key: key,
      children: [
        Expanded(
          flex: 11,
          child: AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) => Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: child,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColor.secondary.withValues(alpha: .16),
                        AppColor.first.withValues(alpha: .04),
                        Colors.transparent,
                      ],
                      stops: const [0, .62, 1],
                    ),
                  ),
                ),
                Image.asset(
                  page.image,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColor.first.withValues(alpha: .08)),
            boxShadow: [
              BoxShadow(
                color: AppColor.primary.withValues(alpha: .08),
                blurRadius: 26,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                decoration: BoxDecoration(
                  color: AppColor.tertiary.withValues(alpha: .75),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(page.header.toUpperCase(), style: AppFonts.label(color: AppColor.first)),
              ),
              const SizedBox(height: 14),
              Text(page.title, style: AppFonts.heading(color: AppColor.text)),
              const SizedBox(height: 9),
              Text(page.description, style: AppFonts.body(color: AppColor.grey)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Row(
                    children: List.generate(onboarding.length, (index) {
                      final isActive = currentpage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsets.only(right: 6),
                        width: isActive ? 22 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColor.first
                              : AppColor.grey.withValues(alpha: .32),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: nextpage,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColor.first,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                      shape: const StadiumBorder(),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(currentpage == onboarding.length - 1 ? 'Get started' : 'Next'),
                        const SizedBox(width: 7),
                        const Icon(Icons.arrow_forward_rounded, size: 17),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
