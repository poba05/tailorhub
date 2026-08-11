import 'package:flutter/material.dart';
import 'package:tailorhub/assets/models/onboarding.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int currentpage = 0;
  double currentPageValue = 0.0;
  late final AnimationController _controller;
  Animation<double> _pulseAnimation = const AlwaysStoppedAnimation(1.0);
  PageController pageController = PageController(initialPage: 0);

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
    currentPageValue = pageController.initialPage.toDouble();
    pageController.addListener(() {
      setState(() {
        currentPageValue =
            pageController.page ?? pageController.initialPage.toDouble();
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void nextpage() {
    if (currentpage < onboarding.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.tertiary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: onboarding.length,
                onPageChanged: (index) {
                  setState(() {
                    currentpage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = onboarding[index];
                  final pageOffset = (currentPageValue - index).abs().clamp(
                    0.0,
                    1.0,
                  );
                  final pageScale = 1 - (pageOffset * 0.08);
                  final pageOpacity = 1 - (pageOffset * 0.35);
                  final pageTranslate = pageOffset * 30;

                  return Opacity(
                    opacity: pageOpacity,
                    child: Transform.translate(
                      offset: Offset(0, pageTranslate),
                      child: Transform.scale(
                        scale: pageScale,
                        child: Stack(
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
                                      child: Image.asset(
                                        page.image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 60),
                                Container(
                                  height: 300,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppColor.background,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                          : AppColor.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                gradient:
                                                    AppGradient.primaryGradient,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: ElevatedButton(
                                                onPressed: nextpage,
                                                style: ElevatedButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 2,
                                                  ),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      currentpage ==
                                                              onboarding
                                                                      .length -
                                                                  1
                                                          ? "Get Started"
                                                          : "Next",
                                                      style:
                                                          AppFonts.buttonText(
                                                            color: AppColor
                                                                .background,
                                                          ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Icon(
                                                      Icons
                                                          .arrow_right_alt_outlined,
                                                      color:
                                                          AppColor.background,
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
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.background
                                      .withValues(alpha: .6),
                                  elevation: 0,
                                ),
                                child: Text(
                                  "Skip",
                                  style: AppFonts.buttonText(
                                    color: AppColor.text,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
