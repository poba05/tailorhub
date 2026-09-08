import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailorhub/models/garment_measurements.dart';

class GarmentMeasurementServices {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<List<GarmentMeasurements>> getMeasurements(
    String garmentTypeId,
  ) async {
    final response = await _supabaseClient
        .from('garment_measurements')
        .select()
        .eq('garment_type_id', garmentTypeId)
        .order('display_order');

    debugPrint('GARMENT ID: $garmentTypeId');
    debugPrint('MEASUREMENTS RESPONSE: $response');

    return (response as List)
        .map((item) => GarmentMeasurements.fromMap(item))
        .toList();
  }
}
