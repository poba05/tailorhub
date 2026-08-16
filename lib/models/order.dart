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
}

List<Order> orderList = [
  Order(
    orderId: "TH-101",
    orderType: "Female Gown",
    orderName: "Plum Silk Evening Gown",
    clientName: "Adaeze okonkwo",
    orderPrice: 320000,
    deadline: DateTime(2026, 8, 17),
    status: "Sewing",
    percentComplete: 72,
  ),
  Order(
    orderId: "TH-102",
    orderType: "Agbada",
    orderName: "Cream Ceremonial Agbabda",
    clientName: "Hakeem Salami",
    orderPrice: 265000,
    deadline: DateTime(2026, 8, 20),
    status: "Cutting",
    percentComplete: 44,
  ),
  Order(
    orderId: "TH-103",
    orderType: "Suit",
    orderName: "Charcoal two-piece Suit",
    clientName: "femi Adebayo",
    orderPrice: 410000,
    deadline: DateTime(2026, 8, 17),
    status: "Ready",
    percentComplete: 92,
  ),
];
