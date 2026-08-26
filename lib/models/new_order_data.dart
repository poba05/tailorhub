import 'package:tailorhub/models/clients.dart';

class NewOrderData {
  Clients? clients;

  String? garmentType;
  String orderName = '';

  DateTime? deadline;

  bool isRush = false;

  String? fabricName;
  String? fabricColor;

  double total = 0;
  double deposit = 0;

  String notes = '';

  double get balance {
    return total - deposit;
  }
}
