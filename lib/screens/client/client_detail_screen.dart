import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/models/clients.dart';
import 'package:tailorhub/models/clients_category.dart';
import 'package:tailorhub/utils/name_utils.dart';

class ClientDetailScreen extends StatelessWidget {
  final Clients client;
  const ClientDetailScreen({super.key, required this.client});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColor.background,
    appBar: AppBar(backgroundColor: AppColor.background, surfaceTintColor: Colors.transparent, title: Text('Client profile', style: AppFonts.bodyLarge(color: AppColor.text))),
    body: ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 28), children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(gradient: AppGradient.primaryGradient, borderRadius: BorderRadius.circular(26), boxShadow: [BoxShadow(color: AppColor.first.withValues(alpha: .20), blurRadius: 22, offset: const Offset(0, 10))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [CircleAvatar(radius: 28, backgroundColor: Colors.white.withValues(alpha: .18), child: Text(getInitials(client.name), style: AppFonts.heading(color: Colors.white))), const Spacer(), _categoryPill(client.category)]),
          const SizedBox(height: 18),
          Text(client.name, style: AppFonts.heading(color: Colors.white)),
          const SizedBox(height: 5),
          Text('Client since —', style: AppFonts.body(color: Colors.white.withValues(alpha: .78))),
        ]),
      ),
      const SizedBox(height: 18),
      Row(children: [Expanded(child: _stat('ORDERS', '—', Icons.content_cut_rounded)), const SizedBox(width: 10), Expanded(child: _stat('LAST VISIT', '—', Icons.event_available_outlined))]),
      const SizedBox(height: 22),
      _section('Contact information'),
      const SizedBox(height: 10),
      _card([
        _info(Icons.phone_outlined, 'Phone number', client.phone?.isNotEmpty == true ? client.phone! : 'Not added'),
        _info(Icons.mail_outline_rounded, 'Email address', client.email?.isNotEmpty == true ? client.email! : 'Not added'),
        _info(Icons.location_on_outlined, 'Location', client.location?.isNotEmpty == true ? client.location! : 'Not added'),
      ]),
      const SizedBox(height: 22),
      Row(children: [Expanded(child: _section('Order history')), TextButton(onPressed: () => _notice(context, 'Order history will appear when order data is connected.'), child: const Text('View all'))]),
      const SizedBox(height: 8),
      _emptyPanel(Icons.receipt_long_outlined, 'No order history yet', 'Orders for this client will be collected here.'),
      const SizedBox(height: 18),
      OutlinedButton.icon(onPressed: () => _notice(context, 'Editing client details will be connected to your client service.'), icon: const Icon(Icons.edit_outlined), label: const Text('Edit client'), style: OutlinedButton.styleFrom(foregroundColor: AppColor.first, minimumSize: const Size.fromHeight(50), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))),
    ]),
  );

  Widget _categoryPill(ClientsCategory category) => Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .18), borderRadius: BorderRadius.circular(20)), child: Text(category.displayName.toUpperCase(), style: AppFonts.label(color: Colors.white)));
  Widget _stat(String label, String value, IconData icon) => Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColor.grey.withValues(alpha: .14))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: AppColor.first), const SizedBox(height: 12), Text(value, style: AppFonts.heading(color: AppColor.text)), Text(label, style: AppFonts.label(color: AppColor.grey))]));
  Widget _section(String value) => Text(value, style: AppFonts.bodyLarge(color: AppColor.text));
  Widget _card(List<Widget> children) => Container(padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColor.grey.withValues(alpha: .14))), child: Column(children: [for (var i = 0; i < children.length; i++) ...[if (i > 0) const Divider(height: 20), children[i]]]));
  Widget _info(IconData icon, String label, String value) => Row(children: [Icon(icon, color: AppColor.first, size: 20), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: AppFonts.body(color: AppColor.grey)), Text(value, style: AppFonts.bodyLarge(color: AppColor.text))]))]);
  Widget _emptyPanel(IconData icon, String title, String description) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColor.grey.withValues(alpha: .14))), child: Row(children: [Icon(icon, color: AppColor.first), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: AppFonts.bodyLarge(color: AppColor.text)), Text(description, style: AppFonts.body(color: AppColor.grey))]))]));
  void _notice(BuildContext context, String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}
