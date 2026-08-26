class Order {
  final String orderId;
  final String orderType;
  final String orderName;
  final String clientName;
  final double orderPrice;
  final DateTime deadline;
  final String status;
  final double percentComplete;

  Order({
    required this.orderId,
    required this.orderType,
    required this.orderName,
    required this.clientName,
    required this.orderPrice,
    required this.deadline,
    required this.status,
    required this.percentComplete,
  });

  static List<Order> latestFirst(List<Order> orders) {
    final sorted = List<Order>.from(orders)
      ..sort((a, b) => b.deadline.compareTo(a.deadline));
    return sorted.take(3).toList();
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    final client = map['clients'] as Map<String, dynamic>?;

    return Order(
      orderId: map['order_number'] as String,
      orderType: map['order_type'] as String,
      orderName: map['order_name'] as String,
      clientName: client?['name'] as String? ?? 'Unknown Client',
      orderPrice: (map['order_price'] as num).toDouble(),
      deadline: DateTime.parse(map['deadline'] as String),
      status: map['status'] as String,
      percentComplete: (map['percent_complete'] as num).toDouble(),
    );
  }
}
