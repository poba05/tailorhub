class GarmentType {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  final bool isActive;

  GarmentType({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    required this.isActive,
  });

  factory GarmentType.fromMap(Map<String, dynamic> map) {
    return GarmentType(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      icon: map['icon'] as String?,
      isActive: map['isActive'] as bool? ?? true,
    );
  }
}
