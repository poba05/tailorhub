import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';

class Custombg extends StatelessWidget {
  final Widget? child;
  const Custombg({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8F3FF), Color(0xFFFCF7F9), Color(0xFFFFFFFF)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            left: -30,
            child: Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColor.first.withValues(alpha: 0.22),
                    AppColor.first.withValues(alpha: 0.02),
                    Colors.transparent,
                  ],
                  stops: const [0.2, 0.7, 1.0],
                ),
              ),
            ),
          ),
          Positioned(
            right: -50,
            bottom: 80,
            child: Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColor.secondary.withValues(alpha: 0.18),
                    AppColor.secondary.withValues(alpha: 0.02),
                    Colors.transparent,
                  ],
                  stops: const [0.2, 0.7, 1.0],
                ),
              ),
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
