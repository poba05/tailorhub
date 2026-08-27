import 'package:flutter/material.dart';
import 'package:tailorhub/models/garment_type.dart';

class GarmentContainer extends StatelessWidget {
  final GarmentType garment;
  const GarmentContainer({super.key, required this.garment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
    );
  }
}
