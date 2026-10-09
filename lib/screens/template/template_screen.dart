import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/constants/fonts.dart';
import 'package:tailorhub/services/garmenttype_service.dart';
import 'package:tailorhub/screens/template/template_editor_screen.dart';
import 'package:tailorhub/widgets/create_btn_popup.dart';
import 'package:tailorhub/widgets/custom_button.dart';
import 'package:tailorhub/widgets/custombg.dart';
import 'package:tailorhub/widgets/empty_state.dart';
import 'package:tailorhub/widgets/skeleton_box.dart';
import 'package:tailorhub/widgets/template_container.dart';

class TemplateScreen extends StatefulWidget {
  const TemplateScreen({super.key});

  @override
  State<TemplateScreen> createState() => _TemplateScreenState();
}

class _TemplateScreenState extends State<TemplateScreen> {
  final GarmenttypeService _garmenttypeService = GarmenttypeService();

  List garmentTypes = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadGarmentTypes();
  }

  Future<void> loadGarmentTypes() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final types = await _garmenttypeService.getGarmentType();

      if (!mounted) return;

      setState(() {
        garmentTypes = types;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Failed to load garment types';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Custombg(
            child: SafeArea(
              child: Stack(
                children: [
                  Positioned.fill(child: buildTemplateContent()),
                  Positioned(top: 0, left: 0, right: 0, child: buildHeader()),
                ],
              ),
            ),
          ),
          const CreateBtnPopup(),
        ],
      ),
    );
  }

  Widget buildTemplateContent() {
    if (isLoading) {
      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: 6,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return const SkeletonBox(
            height: double.infinity,
            width: double.infinity,
          );
        },
      );
    }
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage!, style: AppFonts.body(color: AppColor.grey)),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: loadGarmentTypes,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.sync, size: 20, color: AppColor.background),
                  SizedBox(width: 5),
                  Text(
                    "Retry",
                    style: AppFonts.buttonText(color: AppColor.background),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (garmentTypes.isEmpty) {
      return EmptyState(
        title: "Your template library starts here",
        subTitle: "Save a garment and its measurement fields so you can start future orders faster.",
        buttonText: "Create Template",
        onButtonPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TemplateEditorScreen())),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.only(top: 120, left: 5, right: 5, bottom: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: garmentTypes.length,
      itemBuilder: (context, index) {
        final garmentType = garmentTypes[index];
        return TemplateContainer(garmentType: garmentType);
      },
    );
  }

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, AppColor.background.withValues(alpha: 0.96)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(26),
          bottomRight: Radius.circular(26),
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
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Templates", style: AppFonts.heading(color: AppColor.text)),
              const SizedBox(height: 4),
              Text("Measurement sets for your next order", style: AppFonts.body(color: AppColor.grey)),
            ])),
            IconButton.filled(
              tooltip: 'Create template',
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TemplateEditorScreen())),
              style: IconButton.styleFrom(backgroundColor: AppColor.first, foregroundColor: Colors.white),
              icon: const Icon(Icons.add_rounded),
            ),
          ]),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Total Templates: ",
                      style: AppFonts.body(color: AppColor.text),
                    ),
                    TextSpan(
                      text: "${garmentTypes.length}",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'DMSANS',
                        fontVariations: [FontVariation('wght', 700)],
                        color: AppColor.text,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Active Templates: ",
                      style: AppFonts.body(color: AppColor.text),
                    ),
                    TextSpan(
                      text:
                          "${garmentTypes.where((type) => type.isActive).length}",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'DMSANS',
                        fontVariations: [FontVariation('wght', 700)],
                        color: AppColor.text,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
