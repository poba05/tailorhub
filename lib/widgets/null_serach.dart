import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';

class NullSerach extends StatelessWidget {
  const NullSerach({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded, size: 60, color: AppColor.grey),
          SizedBox(height: 20),
          Text(
            "No Search results",
            style: AppFonts.bodyLarge(color: AppColor.grey),
          ),
        ],
      ),
    );
  }
}
