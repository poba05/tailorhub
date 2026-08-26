import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailorhub/models/order.dart';

class OrderService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  //                                      GET TOP 3 URGENT ORDERS

  Future<List<Order>> getUpcomingOrders() async {
    final user = _supabaseClient.auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final response = await _supabaseClient
        .from('orders')
        .select('''
      id,
      order_number,
      order_type,
      order_name,
      order_price,
      deadline,
      status,
      percent_complete,
      client_id,
      clients (
        id,
        name
      )
    ''')
        .eq('user_id', user.id)
        .order('deadline', ascending: true);

    final orders = response.map<Order>((item) => Order.fromMap(item)).toList();

    orders.sort((a, b) {
      return a.deadline.compareTo(b.deadline);
    });

    return orders.take(3).toList();
  }

  //                                            GET ALL ORDERS

  Future<List<Order>> getAllOrders() async {
    final user = _supabaseClient.auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final response = await _supabaseClient
        .from('orders')
        .select('''
      id,
      order_number,
      order_type,
      order_name,
      order_price,
      deadline,
      status,
      percent_complete,
      client_id,
      clients (
        id,
        name
      )
    ''')
        .eq('user_id', user.id)
        .order('deadline', ascending: true);

    return response.map<Order>((item) => Order.fromMap(item)).toList();
  }

  Future<int> getClientOrderCount(String clientId) async {
    final user = _supabaseClient.auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated');
    }

    final response = await _supabaseClient
        .from('orders')
        .select('id')
        .eq('user_id', user.id)
        .eq('client_id', clientId);

    return response.length;
  }
}
