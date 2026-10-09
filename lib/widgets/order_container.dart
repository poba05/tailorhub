import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/models/order.dart';
import 'package:tailorhub/utils/name_utils.dart';

class OrderContainer extends StatelessWidget {
  final Order order;
  final VoidCallback? onTap;
  const OrderContainer({super.key, required this.order, this.onTap});

  int get daysRemaining {
    final now = DateTime.now();

    final currentDate = DateTime(now.year, now.month, now.day);
    final targetDate = DateTime(
      order.deadline.year,
      order.deadline.month,
      order.deadline.day,
    );

    return targetDate.difference(currentDate).inDays;
  }

  String get remainingTimetext {
    final days = daysRemaining;

    if (days > 1) return "$days days remaining";
    if (days == 1) return "1 day remaining";
    if (days == 0) return "Due Today";
    return "Overdue";
  }

  Color get dateColor {
    final days = daysRemaining;

    if (days > 1) return AppColor.grey;
    if (days == 1) return AppColor.warning;
    if (days == 0) return AppColor.error;
    return AppColor.neutral;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, const Color(0xFFF9F5FF)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          width: 1,
          color: AppColor.grey.withValues(alpha: 0.18),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.first.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  gradient: AppGradient.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    getInitials(order.clientName),
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "DMSANS",
                      fontVariations: [FontVariation('wght', 700)],
                      color: AppColor.background,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${order.orderId.toUpperCase()} • ${order.orderType.toUpperCase()}",
                      style: AppFonts.label(color: AppColor.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      order.orderName,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "DMSANS",
                        fontVariations: [FontVariation('wght', 600)],
                        color: AppColor.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.clientName,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "DMSANS",
                        fontVariations: [FontVariation('wght', 500)],
                        color: AppColor.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
                color: AppColor.grey,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: order.percentComplete / 100,
                    minHeight: 8,
                    backgroundColor: AppColor.grey.withValues(alpha: 0.16),
                    color: AppColor.first,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "${order.percentComplete}%",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "DMSANS",
                  fontVariations: [FontVariation('wght', 200)],
                  color: AppColor.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Builder(
                builder: (_) {
                  final status = order.status.toLowerCase();
                  Color badgeColor;
                  if (status == 'ready') {
                    badgeColor = AppColor.success;
                  } else if (status == 'sewing') {
                    badgeColor = AppColor.error;
                  } else if (status == 'cutting') {
                    badgeColor = AppColor.warning;
                  } else {
                    badgeColor = AppColor.grey;
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "• ${order.status}",
                      style: TextStyle(
                        fontFamily: "DMSANS",
                        fontVariations: [FontVariation('wght', 500)],
                        fontSize: 12,
                        color: badgeColor,
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.calendar_month, size: 10, color: dateColor),
                  const SizedBox(width: 2),
                  Text(
                    remainingTimetext,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "DMSANS",
                      fontVariations: [FontVariation('wght', 500)],
                      color: dateColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Text(
                "₦${order.orderPrice}",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "DMSANS",
                  fontVariations: [FontVariation('wght', 500)],
                  color: AppColor.text,
                ),
              ),
            ],
          ),
        ],
      ),
    )));
  }
}
