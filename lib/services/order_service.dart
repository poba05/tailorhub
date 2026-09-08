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

  Future<String> createOrder(NewOrderData orderData) async {
    final user = _supabaseClient.auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final response = await _supabaseClient
        .from('orders')
        .insert({
          'user_id': user.id,
          'client_id': orderData.clients!.id,
          'garment_type_id': orderData.garment!.id,
          'order_type': orderData.garment!.name,
          'order_name': orderData.orderName,
          'order_price': orderData.total,
          'deadline': orderData.deadline?.toIso8601String().split('T').first,
          'fabric_name': orderData.fabricName,
          'fabric_color': orderData.fabricColor,
          'notes': orderData.notes,
        })
        .select('id')
        .single();

    final orderId = response['id'] as String;

    if (orderData.measurements.isNotEmpty) {
      final measurementRow = orderData.measurements.entries.map((entry) {
        return {
          'order_id': orderId,
          'measurement_id': entry.key,
          'value': entry.value,
        };
      }).toList();

      await _supabaseClient.from('order_measurements').insert(measurementRow);
    }

    return orderId;
  }
}
