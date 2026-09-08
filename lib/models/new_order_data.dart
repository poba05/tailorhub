import 'package:tailorhub/models/clients.dart';
import 'package:tailorhub/models/garment_type.dart';

class NewOrderData {
  Clients? clients;

  GarmentType? garment;
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

  Map<String, double> measurements = {};
}
