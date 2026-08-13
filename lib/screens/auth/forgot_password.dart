import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/widgets/custom_button.dart';
import 'package:tailorhub/widgets/custom_textfield.dart';
import 'package:tailorhub/widgets/custombg.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Custombg(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColor.background,
                    shape: CircleBorder(),
                    side: BorderSide(width: 1, color: AppColor.background),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back, size: 20, color: AppColor.text),
                ),
                SizedBox(height: 50),
                Text(
                  "Recovery".toUpperCase(),
                  style: AppFonts.label(color: AppColor.secondary),
                ),
                SizedBox(height: 10),
                Text(
                  "Lost the Thead?",
                  style: AppFonts.heading(color: AppColor.text),
                ),
                SizedBox(height: 10),
                Text(
                  "Enter the email tied to your studio and we'll\nsend a secure reset link.",
                  style: AppFonts.body(color: AppColor.grey),
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
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                CustomButton(
                  onPressed: () {},
                  child: Text(
                    "RESET",
                    style: AppFonts.buttonText(color: AppColor.background),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
