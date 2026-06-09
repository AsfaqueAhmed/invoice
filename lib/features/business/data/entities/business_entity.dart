import '../../domain/models/business.dart';

class BusinessEntity {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String logo;
  final String currency;

  const BusinessEntity({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.logo,
    required this.currency,
  });

  factory BusinessEntity.fromJson(Map<String, dynamic> json) {
    return BusinessEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      logo: json['logo'] as String,
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'logo': logo,
      'currency': currency,
    };
  }

  factory BusinessEntity.fromDomain(Business business) {
    return BusinessEntity(
      id: business.id,
      name: business.name,
      phone: business.phone,
      address: business.address,
      logo: business.logo,
      currency: business.currency,
    );
  }

  Business toDomain() {
    return Business(
      id: id,
      name: name,
      phone: phone,
      address: address,
      logo: logo,
      currency: currency,
    );
  }
}
