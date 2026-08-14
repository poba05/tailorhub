import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/screens/auth/login_screen.dart';
import 'package:tailorhub/services/auth_service.dart';
import 'package:tailorhub/widgets/custom_button.dart';
import 'package:tailorhub/widgets/custom_textfield.dart';
import 'package:tailorhub/widgets/custombg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final fullNameController = TextEditingController();
  final businessNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    businessNameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppColor.background,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.grey.withValues(alpha: .3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: AppColor.text,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Text(
                    "Create Account".toUpperCase(),
                    style: AppFonts.label(color: AppColor.secondary),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Open your Workbook",
                    style: AppFonts.heading(color: AppColor.text),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Set up your studio in under a minute. Your\nfirst 20 clients are always free.",
                    style: AppFonts.body(color: AppColor.grey),
                  ),
                  SizedBox(height: 30),
                  //                                              TEXTFIELDS
                  Container(
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "FullName".toUpperCase(),
                          style: AppFonts.label(color: AppColor.grey),
                        ),
                        SizedBox(height: 10),
                        CustomTextfield(
                          prefix: Icons.person_outline,
                          hintText: "john doe",
                          controller: fullNameController,
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
                          "Studio name".toUpperCase(),
                          style: AppFonts.label(color: AppColor.grey),
                        ),
                        SizedBox(height: 10),
                        CustomTextfield(
                          prefix: Icons.house_outlined,
                          hintText: "cathyTextiles",
                          controller: businessNameController,
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
                          "Email".toUpperCase(),
                          style: AppFonts.label(color: AppColor.grey),
                        ),
                        SizedBox(height: 10),
                        CustomTextfield(
                          prefix: Icons.mail_outline,
                          hintText: "you@business.com",
                          controller: emailController,
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
                          "password".toUpperCase(),
                          style: AppFonts.label(color: AppColor.grey),
                        ),
                        SizedBox(height: 10),
                        CustomTextfield(
                          prefix: Icons.key_outlined,
                          hintText: "*************",
                          isPassword: true,
                          controller: passwordController,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  //                          END OF TEXTFIELDS
                  Text(
                    "By continuing you agree to the TailorHub Terms of Service and acknowledge our Privacy Policy.",
                    style: AppFonts.body(color: AppColor.grey),
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    isloading: isLoading,
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        final response = await AuthService().signUp(
                          fullname: fullNameController.text.trim(),
                          businessname: businessNameController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        if (!mounted) return;

                        if (response.user != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Account created Successfully'),
                            ),
                          );
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              transitionDuration: const Duration(
                                milliseconds: 500,
                              ),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                    return const LoginScreen();
                                  },
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    final scale =
                                        Tween<double>(
                                          begin: 0.96,
                                          end: 1.0,
                                        ).animate(
                                          CurvedAnimation(
                                            parent: animation,
                                            curve: Curves.easeOutCubic,
                                          ),
                                        );

                                    return FadeTransition(
                                      opacity: animation,
                                      child: ScaleTransition(
                                        scale: scale,
                                        child: child,
                                      ),
                                    );
                                  },
                            ),
                          );
                        }
                      } on AuthException catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(e.message)));
                      } catch (e) {
                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Something went wrong. Please Try again",
                            ),
                          ),
                        );
                      } finally {
                        if (mounted) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                    child: Text(
                      "Signup",
                      style: AppFonts.buttonText(color: AppColor.background),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
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
                                    return const LoginScreen();
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
                          "Sign in",
                          style: TextStyle(
                            fontFamily: "DMSANS",
                            fontVariations: [FontVariation('wght', 700)],
                            fontSize: 14,
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
