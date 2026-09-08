class GarmentMeasurements {
  final String id;
  final String garmentTypeId;
  final String name;
  final String category;
  final String unit;
  final double? defaultValue;
  final bool isRequired;
  final int displayOrder;

  GarmentMeasurements({
    required this.id,
    required this.garmentTypeId,
    required this.name,
    required this.category,
    required this.unit,
    required this.defaultValue,
    required this.isRequired,
    required this.displayOrder,
  });

  factory GarmentMeasurements.fromMap(Map<String, dynamic> map) {
    return GarmentMeasurements(
      id: map['id'] as String,
      garmentTypeId: map['garment_type_id'] as String,
      name: map['name'] as String,
      category: map['category'] as String,
      unit: map['unit'] as String? ?? 'in',
      defaultValue: (map['default_value'] as num?)?.toDouble(),
      isRequired: map['is_required'] as bool? ?? true,
      displayOrder: map['display_order'] as int? ?? 0,
    );
  }
}
