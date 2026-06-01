class CustomerEntity {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String address;
  final String? avatar;
  final double totalDue;

  CustomerEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.address,
    this.avatar,
    required this.totalDue,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'avatar': avatar,
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
        email: map['email'],
        address: map['address'],
        avatar: map['avatar'],
        totalDue: map['totalDue']);
  }
}
