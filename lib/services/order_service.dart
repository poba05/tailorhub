import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tailorhub/models/new_order_data.dart';
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
        .order('deadline', ascending: true)
        .limit(3);

    return response.map<Order>((item) => Order.fromMap(item)).toList();
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

  Future<String> createOrder(NewOrderData orderData) async {
    final user = _supabaseClient.auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final measurementsJson = orderData.measurements.entries
        .map((e) => {'measurement_id': e.key, 'value': e.value})
        .toList();

    final orderId = _supabaseClient
        .rpc(
          'create_orders_with_measurements',
          params: {
            'p_user_id': user.id,
            'p_client_id': orderData.clients!.id,
            'p_garment_type_id': orderData.garment!.id,
            'p_order_type': orderData.garment!.name,
            'p_order_name': orderData.orderName,
            'p_order_price': orderData.total,
            'p_deadline': orderData.deadline
                ?.toIso8601String()
                .split('T')
                .first,
            'p_fabric_name': orderData.fabricName,
            'p_fabric_color': orderData.fabricColor,
            'p_notes': orderData.notes,
            'p_measurements': measurementsJson,
          },
        )
        .toString();

    return orderId;
  }

  Future<int> getActiveOrders() async {
    final user = _supabaseClient.auth.currentUser;

    if (user == null) {
      throw Exception('User is not Logged in');
    }

    final response = await _supabaseClient
        .from('orders')
        .select()
        .eq('user_id', user.id)
        .inFilter('status', ['Cutting', 'Sewing']);

    return response.length;
  }

  Future<int> getCompletdOrders() async {
    final user = _supabaseClient.auth.currentUser;

    if (user == null) {
      throw Exception('User is not Logged in');
    }

    final response = await _supabaseClient
        .from('orders')
        .select()
        .eq('user_id', user.id)
        .eq('status', 'ready');

    return response.length;
  }

  Future<int> getOrdersDueinOneWeek() async {
    final user = _supabaseClient.auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final now = DateTime.now();

    final oneWeekFromNow = now.add(const Duration(days: 7));

    final response = await _supabaseClient
        .from('orders')
        .select()
        .eq('user_id', user.id)
        .gte('deadline', now.toIso8601String())
        .lte('deadline', oneWeekFromNow.toIso8601String());

    return response.length;
  }

  Future<int> getPending() async {
    final user = _supabaseClient.auth.currentUser;

    if (user == null) {
      throw Exception('User is not Logged in');
    }

    final response = await _supabaseClient.rpc('get_orders_with_balance');

    return response.length;
  }
}
