import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailorhub/models/garment_type.dart';

class GarmenttypeService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<List<GarmentType>> getGarmentType() async {
    final user = _supabaseClient.auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final response = await _supabaseClient
        .from('garment_types')
        .select('''
      id,
      user_id,
      name,
      description,
      icon,
      is_active
    ''')
        .eq('is_active', true)
        .or('user_id.is.null,user_id.eq.${user.id}')
        .order('name', ascending: true);

    return response
        .map<GarmentType>((item) => GarmentType.fromMap(item))
        .toList();
  }
}
