class BusinessEntity {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String logo;
  final String currency;

  BusinessEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.logo,
    required this.currency,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'logo': logo,
      'currency': currency
    };
  }

  factory BusinessEntity.fromJson(
    Map<String, dynamic> map,
  ) {
    return BusinessEntity(
        id: map['id'],
        name: map['name'],
        phone: map['phone'],
        address: map['address'],
        logo: map['logo'],
        currency: map['currency']);
  }
}
