class CustomerEntity {
  final String id;
  final String name;
  final String phone;
  final String address;
  final double totalDue;

  CustomerEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.totalDue,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'totalDue': totalDue
    };
  }

  factory CustomerEntity.fromJson(
    Map<String, dynamic> map,
  ) {
    return CustomerEntity(
        id: map['id'],
        name: map['name'],
        phone: map['phone'],
        address: map['address'],
        totalDue: map['totalDue']);
  }
}
