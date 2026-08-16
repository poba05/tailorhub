import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/models/order.dart';
import 'package:tailorhub/utils/name_utils.dart';

class OrderContainer extends StatelessWidget {
  final Order order;
  const OrderContainer({super.key, required this.order});

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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: AppColor.first,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: AppColor.first, width: 1),
                ),
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
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${order.orderId.toUpperCase()} • ${order.orderType.toUpperCase()}",
                    style: AppFonts.label(color: AppColor.grey),
                  ),
                  SizedBox(height: 10),
                  Text(
                    order.orderName,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "DMSANS",
                      fontVariations: [FontVariation('wght', 600)],
                      color: AppColor.text,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    order.clientName,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "DMSANS",
                      fontVariations: [FontVariation('wght', 400)],
                      color: AppColor.text,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios_outlined,
                size: 15,
                color: AppColor.grey,
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              LinearProgressIndicator(
                value: order.percentComplete / 100,
                backgroundColor: AppColor.grey,
                color: AppColor.first,
              ),
              SizedBox(width: 5),
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
          SizedBox(height: 2),
          Row(
            children: [
              // Status badge: color depends on order.status
              Builder(
                builder: (_) {
                  final status = order.status.toLowerCase();
                  Color badgeColor;
                  if (status == 'ready') {
                    badgeColor = AppColor.success;
                  } else if (status == 'sewing') {
                    badgeColor = AppColor.error;
                  } else if (status == 'Cutting') {
                    badgeColor = AppColor.warning;
                  } else {
                    badgeColor = AppColor.grey;
                  }
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: .15),
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
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.calendar_month, size: 10, color: dateColor),
                  SizedBox(width: 2),
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
              SizedBox(width: 5),
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
    );
  }
}
