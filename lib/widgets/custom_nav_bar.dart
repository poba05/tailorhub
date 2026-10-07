import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.dashboard_outlined, 'label': 'Dashboard'},
      {'icon': Icons.people_outlined, 'label': 'Clients'},
      {'icon': Icons.content_cut_outlined, 'label': 'Orders'},
      {'icon': Icons.layers_outlined, 'label': 'Templates'},
      {'icon': Icons.person_outline, 'label': 'Profile'},
    ];
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Container(
          height: 75,
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColor.plainWhite,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: AppColor.grey.withValues(alpha: .15)),
            boxShadow: [
              BoxShadow(
                color: AppColor.first.withValues(alpha: .08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: List.generate(items.length, (index) {
              final isSelected = currentIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColor.first.withValues(alpha: .10)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisAlignment: .center,
                      children: [
                        Icon(
                          items[index]['icon'] as IconData,
                          size: 20,
                          color: isSelected ? AppColor.first : AppColor.grey,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          items[index]['label'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'DMSANS',
                            fontVariations: [FontVariation('wght', 300)],
                            color: isSelected ? AppColor.first : AppColor.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
