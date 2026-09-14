enum ClientsCategory { newClient, regularClient, vipClient, dormantCLient }

extension ClientsCategoryExtension on ClientsCategory {
  String get name {
    switch (this) {
      case ClientsCategory.newClient:
        return 'new';
      case ClientsCategory.regularClient:
        return 'regular';
      case ClientsCategory.vipClient:
        return 'vip';
      case ClientsCategory.dormantCLient:
        return 'dormant';
    }
  }

  String get displayName {
    switch (this) {
      case ClientsCategory.newClient:
        return 'New';
      case ClientsCategory.regularClient:
        return 'Regular';
      case ClientsCategory.vipClient:
        return 'VIP';
      case ClientsCategory.dormantCLient:
        return 'Dormant';
    }
  }
}
