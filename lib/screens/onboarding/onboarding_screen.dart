import 'package:flutter/material.dart';
import 'package:tailorhub/models/onboarding.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/screens/auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int currentpage = 0;
  late final AnimationController _controller;
  Animation<double> _pulseAnimation = const AlwaysStoppedAnimation(1.0);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _pulseAnimation = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextpage() {
    if (currentpage < onboarding.length - 1) {
      setState(() {
        currentpage += 1;
      });
    } else {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const LoginScreen();
          },
          transitionsBuilder: (context, animation, secondaryAnimtion, child) {
            final slide =
                Tween<Offset>(
                  begin: const Offset(0, 0.08),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: slide, child: child),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EEFF),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Builder(
                  key: ValueKey<int>(currentpage),
                  builder: (context) {
                    final page = onboarding[currentpage];

                    return Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 30,
                                  left: 30,
                                  top: 80,
                                  bottom: 20,
                                ),
                                child: ScaleTransition(
                                  scale: _pulseAnimation,
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withValues(alpha: 0.9),
                                          AppColor.primary.withValues(
                                            alpha: 0.06,
                                          ),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColor.primary.withValues(
                                            alpha: 0.08,
                                          ),
                                          blurRadius: 20,
                                          offset: const Offset(0, 12),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      page.image,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            Container(
                              height: 300,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(28),
                                  topRight: Radius.circular(28),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 30,
                                  right: 24,
                                  left: 24,
                                  bottom: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      page.header.toUpperCase(),
                                      style: AppFonts.label(
                                        color: AppColor.error,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      page.title,
                                      style: AppFonts.heading(
                                        color: AppColor.text,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      page.description,
                                      style: AppFonts.bodyLarge(
                                        color: AppColor.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(
                                            onboarding.length,
                                            (index) {
                                              final isActive =
                                                  currentpage == index;

                                              return AnimatedContainer(
                                                duration: const Duration(
                                                  milliseconds: 250,
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                    ),
                                                width: isActive ? 24 : 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                  color: isActive
                                                      ? AppColor.primary
                                                      : AppColor.grey
                                                            .withValues(
                                                              alpha: 0.32,
                                                            ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient:
                                                AppGradient.primaryGradient,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: ElevatedButton(
                                            onPressed: nextpage,
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 2,
                                                  ),
                                              backgroundColor:
                                                  Colors.transparent,
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  currentpage ==
                                                          onboarding.length - 1
                                                      ? "Get Started"
                                                      : "Next",
                                                  style: AppFonts.buttonText(
                                                    color: AppColor.background,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Icon(
                                                  Icons
                                                      .arrow_right_alt_outlined,
                                                  color: AppColor.background,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 6,
                          right: 15,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                        return const LoginScreen();
                                      },
                                  transitionsBuilder:
                                      (
                                        context,
                                        animation,
                                        secondaryAnimtion,
                                        child,
                                      ) {
                                        final slide =
                                            Tween<Offset>(
                                              begin: const Offset(0, 0.08),
                                              end: Offset.zero,
                                            ).animate(
                                              CurvedAnimation(
                                                parent: animation,
                                                curve: Curves.easeOutCubic,
                                              ),
                                            );
                                        return FadeTransition(
                                          opacity: animation,
                                          child: SlideTransition(
                                            position: slide,
                                            child: child,
                                          ),
                                        );
                                      },
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.7,
                              ),
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                            ),
                            child: Text(
                              "Skip",
                              style: AppFonts.buttonText(color: AppColor.text),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
