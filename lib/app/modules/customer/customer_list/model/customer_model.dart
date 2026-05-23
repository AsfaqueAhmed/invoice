class CustomerModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? address;
  final String? businessName;
  final String? avatarUrl;
  final CustomerStatus status;
  final double totalPurchases;
  final double totalPaid;
  final double totalDue;
  final DateTime? lastInvoiceDate;
  final List<InvoicePreview> invoices;
  final int overdueCount;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.address,
    this.businessName,
    this.avatarUrl,
    required this.status,
    this.totalPurchases = 0,
    this.totalPaid = 0,
    this.totalDue = 0,
    this.lastInvoiceDate,
    this.invoices = const [],
    this.overdueCount = 0,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

enum CustomerStatus { active, newContract, overdue, vip, inactive }

extension CustomerStatusExt on CustomerStatus {
  String get label {
    switch (this) {
      case CustomerStatus.active:
        return 'Active Account';
      case CustomerStatus.newContract:
        return 'New Contract';
      case CustomerStatus.overdue:
        return 'Overdue 14 Days';
      case CustomerStatus.vip:
        return 'VIP Customer';
      case CustomerStatus.inactive:
        return 'Inactive (30d+)';
    }
  }
}

class InvoicePreview {
  final String invoiceNumber;
  final double amount;
  final DateTime date;
  final InvoiceStatus status;

  InvoicePreview({
    required this.invoiceNumber,
    required this.amount,
    required this.date,
    required this.status,
  });
}

enum InvoiceStatus { paid, overdue, pending }

extension InvoiceStatusExt on InvoiceStatus {
  String get label {
    switch (this) {
      case InvoiceStatus.paid:
        return 'PAID';
      case InvoiceStatus.overdue:
        return 'OVERDUE';
      case InvoiceStatus.pending:
        return 'PENDING';
    }
  }
}
