import 'package:flutter/material.dart';
import 'package:tailorhub/constants/colors.dart';
import 'package:tailorhub/models/garment_type.dart';
import 'package:tailorhub/utils/name_utils.dart';

class TemplateContainer extends StatelessWidget {
  final GarmentType garmentType;
  const TemplateContainer({super.key, required this.garmentType});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      constraints: const BoxConstraints(minHeight: 150),
      decoration: BoxDecoration(
        color: AppColor.plainWhite,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColor.grey.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: AppColor.first.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              gradient: AppGradient.primaryGradient,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: AppColor.first.withValues(alpha: 0.22),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Text(
                getInitials(garmentType.name),
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "DMSANS",
                  fontVariations: [FontVariation('wght', 700)],
                  color: AppColor.background,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            garmentType.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontFamily: "DMSANS",
              fontVariations: [FontVariation('wght', 600)],
              color: AppColor.text,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              garmentType.description?.trim().isNotEmpty == true
                  ? garmentType.description!
                  : 'Custom garment template',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontFamily: "DMSANS",
                fontVariations: [FontVariation('wght', 400)],
                color: AppColor.grey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
