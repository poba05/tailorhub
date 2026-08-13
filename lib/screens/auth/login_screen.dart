import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/screens/auth/forgot_password.dart';
import 'package:tailorhub/screens/auth/signup_screen.dart';
import 'package:tailorhub/widgets/custom_button.dart';
import 'package:tailorhub/widgets/custom_textfield.dart';
import 'package:tailorhub/widgets/custombg.dart';
import 'package:tailorhub/widgets/plain_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool ischecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Custombg(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("lib/assets/images/hero_icon.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "WELCOME BACK",
                    style: AppFonts.label(color: AppColor.secondary),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Step into the atelier",
                    style: AppFonts.heading(color: AppColor.neutral),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your client book, measurements and orders\nare exactly where you left them.",
                    style: AppFonts.bodyLarge(color: AppColor.grey),
                  ),
                  SizedBox(height: 30),

                  //                                  TEXT FIELDS
                  Container(
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email".toUpperCase(),
                          style: AppFonts.label(color: AppColor.grey),
                        ),
                        SizedBox(height: 10),
                        CustomTextfield(
                          hintText: "you@gmail.com",
                          prefix: Icons.mail_outline,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Password".toUpperCase(),
                          style: AppFonts.label(color: AppColor.grey),
                        ),
                        SizedBox(height: 10),
                        CustomTextfield(
                          hintText: "**************",
                          prefix: Icons.key,
                          isPassword: true,
                        ),
                      ],
                    ),
                  ),
                  //                      END OF TEXTFIELD
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          value: ischecked,
                          onChanged: (value) {
                            setState(() {
                              ischecked = value ?? false;
                            });
                          },
                          title: Text(
                            "keep me signed in",
                            style: AppFonts.body(color: AppColor.grey),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: AppColor.first,
                          checkColor: AppColor.background,
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                            vertical: -4,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                    return const ForgotPassword();
                                  },
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
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
                        child: Text(
                          "Forgot Password?",
                          style: AppFonts.body(color: AppColor.first),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  //                      LOGIN BUTTON
                  CustomButton(
                    onPressed: () {},
                    child: Text(
                      "Sign in",
                      style: AppFonts.buttonText(color: AppColor.background),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: AppColor.grey, thickness: 1),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "or",
                          style: AppFonts.bodyLarge(color: AppColor.grey),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: AppColor.grey, thickness: 1),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  //                                      GOOGLE AND APPLE SIGIN BUTTON
                  Row(
                    children: [
                      Expanded(
                        child: PlainButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.android_outlined,
                                size: 20,
                                color: AppColor.first,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  "Google",
                                  style: TextStyle(
                                    fontFamily: "DMSANS",
                                    fontVariations: [
                                      FontVariation('wght', 700),
                                    ],
                                    color: AppColor.text,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PlainButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.apple,
                                size: 20,
                                color: AppColor.first,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  "Apple",
                                  style: TextStyle(
                                    fontFamily: "DMSANS",
                                    fontVariations: [
                                      FontVariation('wght', 700),
                                    ],
                                    color: AppColor.text,
                                    fontSize: 16,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "New to TailorHub?",
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "DMSANS",
                          fontVariations: [FontVariation('wght', 300)],
                          color: AppColor.grey,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                    return const SignupScreen();
                                  },
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
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
                        child: Text(
                          "Create an Account",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "DMSANS",
                            fontVariations: [FontVariation('wght', 500)],
                            color: AppColor.first,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
