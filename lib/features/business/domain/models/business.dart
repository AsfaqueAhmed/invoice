class Business {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String logo;
  final String currency;

  const Business({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.logo,
    required this.currency,
  });

  Business copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    String? logo,
    String? currency,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      logo: logo ?? this.logo,
      currency: currency ?? this.currency,
    );
  }
}
