import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';

class ColorCircle extends StatelessWidget {
  final Color color;
  final bool isSelected;
  const ColorCircle({super.key, required this.color, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: .circle,
        border: Border.all(
          color: isSelected ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(shape: .circle, color: color),
        child: isSelected
            ? Icon(Icons.check, size: 10, color: AppColor.plainWhite)
            : null,
      ),
    );
  }
}
