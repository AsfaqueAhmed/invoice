class ExpenseEntity {
  final String id;
  final String category;
  final double amount;
  final String note;

  ExpenseEntity({
    required this.id,
    required this.category,
    required this.amount,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'category': category, 'amount': amount, 'note': note};
  }

  factory ExpenseEntity.fromJson(
    Map<String, dynamic> map,
  ) {
    return ExpenseEntity(
        id: map['id'],
        category: map['category'],
        amount: map['amount'],
        note: map['note']);
  }
}
