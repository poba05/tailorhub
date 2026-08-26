import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailorhub/models/clients.dart';

class ClientServices {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<List<Clients>> getclients() async {
    final user = _supabaseClient.auth.currentUser;

    if (user == null) {
      throw Exception("User is not Aunthenticated");
    }

    final response = await _supabaseClient
        .from('clients')
        .select('''
            id,
            name,
            phone,
            email
        ''')
        .eq('user_id', user.id)
        .order('name', ascending: true);

    return response.map<Clients>((item) => Clients.fromMap(item)).toList();
  }
}
