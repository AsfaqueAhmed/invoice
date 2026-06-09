class Customer {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String address;
  final String? avatar;
  final double totalDue;

  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.address,
    this.avatar,
    required this.totalDue,
  });

  Customer copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    String? avatar,
    double? totalDue,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      avatar: avatar ?? this.avatar,
      totalDue: totalDue ?? this.totalDue,
    );
  }
}
