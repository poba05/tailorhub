import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tailorhub/constants/colors.dart';

class SkeletonBox extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.grey.withValues(alpha: .15),
      highlightColor: AppColor.grey.withValues(alpha: .05),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
