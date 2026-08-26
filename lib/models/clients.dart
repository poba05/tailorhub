class Clients {
  final String id;
  final String name;
  final String? phone;
  final String? email;

  Clients({required this.id, required this.name, this.phone, this.email});

  factory Clients.fromMap(Map<String, dynamic> map) {
    return Clients(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String?,
      phone: map['phone'] as String?,
    );
  }
}
