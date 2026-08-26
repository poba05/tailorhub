import 'package:flutter_test/flutter_test.dart';
import 'package:tailorhub/models/order.dart';

void main() {
  test('returns the latest three orders by deadline', () {
    final orders = [
      Order(
        orderId: '1',
        orderType: 'Suit',
        orderName: 'First',
        clientName: 'Alice',
        orderPrice: 100,
        deadline: DateTime(2025, 1, 1),
        status: 'Pending',
        percentComplete: 20,
      ),
      Order(
        orderId: '2',
        orderType: 'Suit',
        orderName: 'Second',
        clientName: 'Bob',
        orderPrice: 200,
        deadline: DateTime(2025, 1, 10),
        status: 'Pending',
        percentComplete: 20,
      ),
      Order(
        orderId: '3',
        orderType: 'Suit',
        orderName: 'Third',
        clientName: 'Chloe',
        orderPrice: 300,
        deadline: DateTime(2025, 1, 5),
        status: 'Progress',
        percentComplete: 50,
      ),
      Order(
        orderId: '4',
        orderType: 'Suit',
        orderName: 'Fourth',
        clientName: 'Dora',
        orderPrice: 400,
        deadline: DateTime(2025, 1, 20),
        status: 'Completed',
        percentComplete: 100,
      ),
      Order(
        orderId: '5',
        orderType: 'Suit',
        orderName: 'Fifth',
        clientName: 'Ethan',
        orderPrice: 500,
        deadline: DateTime(2025, 1, 15),
        status: 'Progress',
        percentComplete: 75,
      ),
    ];

    final latestOrders = Order.latestFirst(orders);

    expect(latestOrders.length, 3);
    expect(latestOrders.map((order) => order.orderName).toList(), [
      'Fourth',
      'Fifth',
      'Second',
    ]);
  });
}
