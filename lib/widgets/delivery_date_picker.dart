import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';

class DeliveryDatePicker extends StatefulWidget {
  final DateTime? selectedDate;
  final bool isRush;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<bool> onRushChanged;

  const DeliveryDatePicker({
    super.key,
    required this.selectedDate,
    required this.isRush,
    required this.onDateSelected,
    required this.onRushChanged,
  });

  @override
  State<DeliveryDatePicker> createState() => _DeliveryDatePickerState();
}

class _DeliveryDatePickerState extends State<DeliveryDatePicker> {
  late DateTime focusedDay;

  @override
  void initState() {
    super.initState();

    focusedDay = widget.selectedDate ?? DateTime.now();
  }

  @override
  void didUpdateWidget(covariant DeliveryDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selectedDate != oldWidget.selectedDate &&
        widget.selectedDate != null) {
      focusedDay = widget.selectedDate!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = widget.selectedDate;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColor.plainWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColor.grey.withValues(alpha: .2)),
        boxShadow: [
          BoxShadow(
            color: AppColor.grey.withValues(alpha: .12),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: AppColor.first.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.calendar_month_outlined,
                  color: AppColor.first,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'DELIVERY DATE',
                      style: AppFonts.label(color: AppColor.grey),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      selectedDate == null
                          ? 'Select a date'
                          : formatDate(selectedDate),
                      style: AppFonts.bodyLarge(color: AppColor.text),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Calendar
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime(DateTime.now().year + 2, 12, 31),
            focusedDay: focusedDay,

            selectedDayPredicate: (day) {
              if (selectedDate == null) {
                return false;
              }

              return isSameDay(selectedDate, day);
            },

            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                this.focusedDay = focusedDay;
              });

              widget.onDateSelected(selectedDay);
            },

            onPageChanged: (focusedDay) {
              setState(() {
                this.focusedDay = focusedDay;
              });
            },

            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColor.first.withValues(alpha: .15),
                shape: BoxShape.circle,
              ),

              todayTextStyle: TextStyle(
                color: AppColor.first,
                fontFamily: 'DMSANS',
                fontWeight: FontWeight.w600,
              ),

              selectedDecoration: BoxDecoration(
                color: AppColor.first,
                shape: BoxShape.circle,
              ),

              selectedTextStyle: TextStyle(
                color: AppColor.background,
                fontFamily: 'DMSANS',
                fontWeight: FontWeight.w700,
              ),

              outsideDaysVisible: false,
            ),

            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                final text = [
                  'M',
                  'T',
                  'W',
                  'T',
                  'F',
                  'S',
                  'S',
                ][day.weekday - 1];
                return Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'DMSANS',
                      color: AppColor.grey,
                    ),
                  ),
                );
              },
            ),
            daysOfWeekHeight: 22,
            rowHeight: 30,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: AppColor.text,
                size: 18,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: AppColor.text,
                size: 18,
              ),
              titleTextStyle: TextStyle(
                fontSize: 14,
                fontFamily: 'DMSANS',
                fontWeight: FontWeight.w700,
                color: AppColor.text,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Rush job
          GestureDetector(
            onTap: () => widget.onRushChanged(!widget.isRush),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColor.background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: widget.isRush
                          ? AppColor.first
                          : Colors.transparent,
                      border: Border.all(
                        color: widget.isRush
                            ? AppColor.first
                            : AppColor.grey.withValues(alpha: .5),
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: widget.isRush
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      'Rush job — prioritise in the workroom',
                      style: AppFonts.body(color: AppColor.text),
                    ),
                  ),

                  SizedBox(width: 4),

                  Icon(Icons.auto_awesome, size: 18, color: AppColor.primary),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];

    return '$weekday, ${date.day} $month ${date.year}';
  }
}
