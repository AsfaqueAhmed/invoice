class PaymentEntity {
  final String id;
  final String invoiceId;
  final double amount;
  final String method;
  final String note;

  PaymentEntity({
    required this.id,
    required this.invoiceId,
    required this.amount,
    required this.method,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoiceId': invoiceId,
      'amount': amount,
      'method': method,
      'note': note
    };
  }

  factory PaymentEntity.fromJson(
    Map<String, dynamic> map,
  ) {
    return PaymentEntity(
        id: map['id'],
        invoiceId: map['invoiceId'],
        amount: map['amount'],
        method: map['method'],
        note: map['note']);
  }
}
