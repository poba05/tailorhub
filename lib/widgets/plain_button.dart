import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';

class PlainButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  const PlainButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: null,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(
              width: 1,
              color: AppColor.grey.withValues(alpha: 0.18),
            ),
          ),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ).copyWith(overlayColor: MaterialStateProperty.all(Colors.transparent)),
        child: child,
      ),
    );
  }
}
