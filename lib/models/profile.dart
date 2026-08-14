class Profile {
  final String id;
  final String userId;
  final String fullName;
  final String businessName;

  Profile({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.businessName,
  });

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      userId: map['user_id'],
      fullName: map['full_name'],
      businessName: map['business_name'],
    );
  }
}
