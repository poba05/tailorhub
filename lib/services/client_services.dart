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

  Future<void> createNewClient({
    required String name,
    required String phone,
    String? email,
    required String category,
    String? location,
  }) async {
    final user = _supabaseClient.auth.currentUser;

    if (user == null) {
      throw Exception('User not Logged in');
    }

    await _supabaseClient.from('clients').insert({
      'user_id': user.id,
      'name': name,
      'phone': phone,
      'email': email,
      'category': category,
      'location': location,
    });
  }

  Future<int> getClientsCreatedThisMonth() async {
    final user = _supabaseClient.auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final now = DateTime.now();

    final startOfMonth = DateTime(now.year, now.month, 1);

    final response = await _supabaseClient
        .from('clients')
        .select()
        .eq('user_id', user.id)
        .gte('created_at', startOfMonth.toIso8601String());

    return response.length;
  }
}
