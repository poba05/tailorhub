import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/widgets/custom_button.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String subTitle;
  final String buttonText;
  const EmptyState({
    super.key,
    required this.title,
    required this.subTitle,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.grey.withValues(alpha: .3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty, size: 40, color: AppColor.primary),

          const SizedBox(height: 15),

          Text(title, style: AppFonts.heading(color: AppColor.text)),

          const SizedBox(height: 5),

          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: AppFonts.body(color: AppColor.grey),
          ),

          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: AppColor.primary,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 20, color: AppColor.background),
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
