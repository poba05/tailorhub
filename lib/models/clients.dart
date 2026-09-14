import 'package:tailorhub/models/clients_category.dart';

class Clients {
  final String id;
  final String name;
  final ClientsCategory category;
  final String? phone;
  final String? email;
  final String? location;

  Clients({
    required this.id,
    required this.name,
    required this.category,
    this.phone,
    this.email,
    this.location,
  });

  static List<Clients> latestFirst(List<Clients> clients) {
    return List<Clients>.from(clients);
  }

  factory Clients.fromMap(Map<String, dynamic> map) {
    return Clients(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
      category: _categoryFromString(map['category'] as String?),
      location: map['location'] as String?,
    );
  }

  static ClientsCategory _categoryFromString(String? category) {
    switch (category) {
      case 'VIP':
        return ClientsCategory.vipClient;
      case 'Regular':
        return ClientsCategory.regularClient;
      case 'Dormant':
        return ClientsCategory.dormantCLient;
      case 'New':
      default:
        return ClientsCategory.newClient;
    }
  }
}
