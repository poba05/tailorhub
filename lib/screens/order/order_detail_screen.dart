import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/models/order.dart';
import 'package:tailorhub/utils/name_utils.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final money = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 0,
    );
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.background,
        surfaceTintColor: Colors.transparent,
        title: Text(
          order.orderId.toUpperCase(),
          style: AppFonts.bodyLarge(color: AppColor.text),
        ),
        actions: [
          IconButton(
            onPressed: () => _notice(
              context,
              'Order editing will be connected to your order flow.',
            ),
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppGradient.primaryGradient,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  color: AppColor.first.withValues(alpha: .2),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 23,
                      backgroundColor: Colors.white.withValues(alpha: .18),
                      child: Text(
                        getInitials(order.clientName),
                        style: AppFonts.bodyLarge(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.clientName,
                            style: AppFonts.bodyLarge(color: Colors.white),
                          ),
                          Text(
                            order.orderType,
                            style: AppFonts.body(
                              color: Colors.white.withValues(alpha: .78),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _statusPill(order.status),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  order.orderName,
                  style: AppFonts.heading(color: Colors.white),
                ),
                const SizedBox(height: 6),
                Text(
                  'Due ${DateFormat('EEE, d MMM yyyy').format(order.deadline)}',
                  style: AppFonts.body(
                    color: Colors.white.withValues(alpha: .82),
                  ),
                ),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: (order.percentComplete / 100).clamp(0, 1).toDouble(),
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: .2),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  '${order.percentComplete.toStringAsFixed(0)}% complete',
                  style: AppFonts.body(
                    color: Colors.white.withValues(alpha: .85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _section('Order overview'),
          const SizedBox(height: 10),
          _card([
            _row(
              'Total price',
              money.format(order.orderPrice),
              Icons.payments_outlined,
            ),
            _row('Order status', order.status, Icons.track_changes_outlined),
            _row(
              'Delivery date',
              DateFormat('d MMM yyyy').format(order.deadline),
              Icons.event_outlined,
            ),
          ]),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: _section('Style references')),
              TextButton.icon(
                onPressed: () => _notice(
                  context,
                  'Photo selection and storage will be connected to your backend.',
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add photo'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 116,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.grey.withValues(alpha: .16)),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 28,
                    color: AppColor.first,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Keep the client’s inspiration with this order',
                    style: AppFonts.body(color: AppColor.grey),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),
          _section('Measurements'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.grey.withValues(alpha: .14)),
            ),
            child: Row(
              children: [
                const Icon(Icons.straighten_rounded, color: AppColor.first),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Measurement values will show here when the order measurement query is connected.',
                    style: AppFonts.body(color: AppColor.grey),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => _notice(
              context,
              'Status updates will be connected to your order service.',
            ),
            icon: const Icon(Icons.autorenew_rounded),
            label: const Text('Update order status'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColor.first,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusPill(String status) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .18),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      status.toUpperCase(),
      style: AppFonts.label(color: Colors.white),
    ),
  );
  Widget _section(String title) =>
      Text(title, style: AppFonts.bodyLarge(color: AppColor.text));
  Widget _card(List<Widget> children) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColor.grey.withValues(alpha: .14)),
    ),
    child: Column(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const Divider(height: 20),
          children[i],
        ],
      ],
    ),
  );
  Widget _row(String label, String value, IconData icon) => Row(
    children: [
      Icon(icon, color: AppColor.first, size: 20),
      const SizedBox(width: 12),
      Expanded(
        child: Text(label, style: AppFonts.body(color: AppColor.grey)),
      ),
      Text(value, style: AppFonts.bodyLarge(color: AppColor.text)),
    ],
  );
  void _notice(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
