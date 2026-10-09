import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/widgets/custom_button.dart';
import 'package:tailorhub/widgets/custom_textfield.dart';

class TemplateEditorScreen extends StatefulWidget {
  const TemplateEditorScreen({super.key});

  @override
  State<TemplateEditorScreen> createState() => _TemplateEditorScreenState();
}

class _TemplateEditorScreenState extends State<TemplateEditorScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final List<_MeasurementDraft> measurements = [_MeasurementDraft('Chest'), _MeasurementDraft('Waist'), _MeasurementDraft('Length')];

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColor.background,
    appBar: AppBar(title: Text('New template', style: AppFonts.bodyLarge(color: AppColor.text)), backgroundColor: AppColor.background, surfaceTintColor: Colors.transparent),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
      children: [
        Text('Build a measurement set', style: AppFonts.heading(color: AppColor.text)),
        const SizedBox(height: 6),
        Text('Create a reusable starting point for your next order.', style: AppFonts.body(color: AppColor.grey)),
        const SizedBox(height: 22),
        _panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _label('TEMPLATE DETAILS'),
          const SizedBox(height: 14),
          CustomTextfield(controller: nameController, hintText: 'e.g. Classic shirt', prefix: Icons.checkroom_outlined),
          const SizedBox(height: 12),
          CustomTextfield(controller: descriptionController, hintText: 'Add a short description', prefix: Icons.notes_rounded),
        ])),
        const SizedBox(height: 18),
        Row(children: [Expanded(child: Text('Measurements', style: AppFonts.bodyLarge(color: AppColor.text))), Text('${measurements.length} fields', style: AppFonts.body(color: AppColor.grey))]),
        const SizedBox(height: 10),
        ...measurements.asMap().entries.map((entry) => _measurementTile(entry.key, entry.value)),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => setState(() => measurements.add(_MeasurementDraft('New measurement'))),
          icon: const Icon(Icons.add_rounded),
          label: const Text('Add measurement'),
          style: OutlinedButton.styleFrom(foregroundColor: AppColor.first, minimumSize: const Size.fromHeight(50), side: BorderSide(color: AppColor.first.withValues(alpha: .35)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
        ),
        const SizedBox(height: 18),
        _panel(child: Row(children: [const Icon(Icons.tips_and_updates_outlined, color: AppColor.first), const SizedBox(width: 12), Expanded(child: Text('Templates save the measurement fields you commonly use. You can adjust values for each order.', style: AppFonts.body(color: AppColor.grey)))])),
      ],
    ),
    bottomSheet: SafeArea(child: Container(padding: const EdgeInsets.all(16), decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFE9E3EF)))), child: CustomButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Template saving will be connected to your backend.'))), child: Text('Save template', style: AppFonts.buttonText(color: Colors.white))))),
  );

  Widget _measurementTile(int index, _MeasurementDraft draft) => Container(
    margin: const EdgeInsets.only(bottom: 9),
    padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColor.grey.withValues(alpha: .16))),
    child: Row(children: [
      Container(height: 38, width: 38, decoration: BoxDecoration(color: AppColor.tertiary, borderRadius: BorderRadius.circular(12)), child: Center(child: Text('${index + 1}', style: AppFonts.bodyLarge(color: AppColor.first)))),
      const SizedBox(width: 12),
      Expanded(child: Text(draft.name, style: AppFonts.bodyLarge(color: AppColor.text))),
      Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: AppColor.background, borderRadius: BorderRadius.circular(10)), child: Text('in', style: AppFonts.body(color: AppColor.grey))),
      IconButton(onPressed: () => setState(() => measurements.removeAt(index)), icon: const Icon(Icons.remove_circle_outline_rounded), color: AppColor.grey),
    ]),
  );

  Widget _panel({required Widget child}) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: AppColor.grey.withValues(alpha: .16)), boxShadow: [BoxShadow(color: AppColor.first.withValues(alpha: .04), blurRadius: 15, offset: const Offset(0, 5))]), child: child);
  Widget _label(String value) => Text(value, style: AppFonts.label(color: AppColor.grey));
}

class _MeasurementDraft {
  final String name;
  const _MeasurementDraft(this.name);
}
