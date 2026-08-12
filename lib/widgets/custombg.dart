import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';

class Custombg extends StatelessWidget {
  final Widget? child;
  const Custombg({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: AppColor.background),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            left: -70,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColor.secondary.withValues(alpha: .1),
                    spreadRadius: 90,
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
