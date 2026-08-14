import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailorhub/models/profile.dart';

class ProfileService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<Profile?> getCurrentProfile() async {
    final user = _supabaseClient.auth.currentUser;

    if (user == null) {
      return null;
    }

    final data = await _supabaseClient
        .from('profiles')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    if (data == null) {
      return null;
    }

    return Profile.fromMap(data);
  }
}
