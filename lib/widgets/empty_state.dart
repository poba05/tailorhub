import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/widgets/custom_button.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String subTitle;
  final String buttonText;
  final VoidCallback? onButtonPressed;
  final IconData buttonIcon;
  const EmptyState({
    super.key,
    required this.title,
    required this.subTitle,
    required this.buttonText,
    this.onButtonPressed,
    this.buttonIcon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColor.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: AppColor.first.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 74,
            width: 74,
            decoration: BoxDecoration(
              gradient: AppGradient.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColor.primary.withValues(alpha: 0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.hourglass_empty,
              size: 34,
              color: AppColor.background,
            ),
          ),

          const SizedBox(height: 18),

          Text(title, style: AppFonts.heading(color: AppColor.text)),

          const SizedBox(height: 6),

          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: AppFonts.body(color: AppColor.grey),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: onButtonPressed,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              backgroundColor: AppColor.primary,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(buttonIcon, size: 20, color: AppColor.background),
                const SizedBox(width: 8),
                Text(
                  buttonText,
                  style: AppFonts.buttonText(color: AppColor.background),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
