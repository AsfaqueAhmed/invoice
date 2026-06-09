import '../../domain/models/customer.dart';

class CustomerEntity {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String address;
  final String? avatar;
  final double totalDue;

  const CustomerEntity({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.address,
    this.avatar,
    required this.totalDue,
  });

  factory CustomerEntity.fromJson(Map<String, dynamic> json) {
    return CustomerEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      address: json['address'] as String,
      avatar: json['avatar'] as String?,
      totalDue: (json['totalDue'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'avatar': avatar,
      'totalDue': totalDue,
    };
  }

  factory CustomerEntity.fromDomain(Customer customer) {
    return CustomerEntity(
      id: customer.id,
      name: customer.name,
      phone: customer.phone,
      email: customer.email,
      address: customer.address,
      avatar: customer.avatar,
      totalDue: customer.totalDue,
    );
  }

  Customer toDomain() {
    return Customer(
      id: id,
      name: name,
      phone: phone,
      email: email,
      address: address,
      avatar: avatar,
      totalDue: totalDue,
    );
  }
}
