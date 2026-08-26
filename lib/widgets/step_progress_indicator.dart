import 'package:flutter/cupertino.dart';
import 'package:tailorhub/constants/colors.dart';

class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index.isEven) {
          final step = index ~/ 2;

          return Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: step <= currentStep
                  ? AppColor.first
                  : AppColor.grey.withValues(alpha: .3),
            ),
          );
        }

        return Expanded(
          child: Row(
            children: List.generate(
              5,
              (_) => Expanded(
                child: Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  color: AppColor.grey.withValues(alpha: .3),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
