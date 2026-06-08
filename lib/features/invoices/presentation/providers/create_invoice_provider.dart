import 'package:flutter/foundation.dart';
import 'package:flutter_getx_app/features/customer/data/providers.dart';
import 'package:flutter_getx_app/features/customer/domain/entities/customer_entity.dart';
import 'package:flutter_getx_app/features/product/data/providers.dart';
import 'package:flutter_getx_app/features/product/domain/entities/product_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/providers.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/invoice_item_entity.dart';
import 'invoice_list_provider.dart';

/// Customers/products available to pick from when building an invoice.
/// Plain `FutureProvider`s so the picker sheets get loading/error states for
/// free, and so re-fetching after "add new" is just `ref.invalidate(...)`.
final availableCustomersProvider = FutureProvider<List<CustomerEntity>>((ref) {
  return ref.watch(customerRepositoryProvider).getAll();
});

final availableProductsProvider = FutureProvider<List<ProductEntity>>((ref) {
  return ref.watch(productRepositoryProvider).getAll();
});

/// The invoice currently being composed: chosen customer, line items,
/// discount and amount paid so far. Totals are derived getters so the UI
/// never has to recompute them by hand.
class CreateInvoiceCart {
  const CreateInvoiceCart({
    required this.invoiceNo,
    this.selectedCustomer,
    this.items = const [],
    this.discountPercent = 10,
    this.amountPaid = 0,
    this.isSaving = false,
  });

  final String invoiceNo;
  final CustomerEntity? selectedCustomer;
  final List<ProductEntity> items;
  final double discountPercent;
  final double amountPaid;
  final bool isSaving;

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + (item.quantity ?? 0) * item.sellingPrice);

  double get grandTotal => subtotal * (1 - discountPercent / 100);

  double get dueAmount => (grandTotal - amountPaid).clamp(0, double.infinity);

  CreateInvoiceCart copyWith({
    CustomerEntity? selectedCustomer,
    List<ProductEntity>? items,
    double? discountPercent,
    double? amountPaid,
    bool? isSaving,
  }) {
    return CreateInvoiceCart(
      invoiceNo: invoiceNo,
      selectedCustomer: selectedCustomer ?? this.selectedCustomer,
      items: items ?? this.items,
      discountPercent: discountPercent ?? this.discountPercent,
      amountPaid: amountPaid ?? this.amountPaid,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

final createInvoiceProvider =
    NotifierProvider<CreateInvoiceNotifier, CreateInvoiceCart>(
  CreateInvoiceNotifier.new,
);

class CreateInvoiceNotifier extends Notifier<CreateInvoiceCart> {
  @override
  CreateInvoiceCart build() => CreateInvoiceCart(invoiceNo: _generateInvoiceNo());

  void selectCustomer(CustomerEntity customer) {
    state = state.copyWith(selectedCustomer: customer);
  }

  /// Adds [product] to the cart with quantity 1. Returns false without
  /// changing the cart if the product is already in it.
  bool addProduct(ProductEntity product) {
    if (state.items.any((item) => item.id == product.id)) return false;
    product.quantity = 1;
    state = state.copyWith(items: [...state.items, product]);
    return true;
  }

  void incrementQty(int index) {
    final items = [...state.items];
    final item = items[index];
    item.quantity = (item.quantity ?? 0) + 1;
    state = state.copyWith(items: items);
  }

  void decrementQty(int index) {
    final item = state.items[index];
    if ((item.quantity ?? 0) <= 1) {
      removeItem(index);
      return;
    }
    final items = [...state.items];
    item.quantity = (item.quantity ?? 0) - 1;
    state = state.copyWith(items: items);
  }

  void removeItem(int index) {
    final items = [...state.items]..removeAt(index);
    state = state.copyWith(items: items);
  }

  void setDiscountPercent(double percent) =>
      state = state.copyWith(discountPercent: percent);

  void setAmountPaid(double amount) =>
      state = state.copyWith(amountPaid: amount);

  /// Persists the invoice with its line items. Returns an error message on
  /// failure, or `null` on success.
  Future<String?> save() async {
    if (state.selectedCustomer == null) return 'Please select a customer.';
    if (state.items.isEmpty) return 'Please add at least one item.';

    state = state.copyWith(isSaving: true);
    try {
      final invoiceId = const Uuid().v4();
      final invoice = InvoiceEntity(
        id: invoiceId,
        customerId: state.selectedCustomer!.id,
        invoiceNo: state.invoiceNo,
        subtotal: state.subtotal,
        discount: state.discountPercent,
        tax: 0,
        total: state.grandTotal,
        paid: state.amountPaid,
        due: state.dueAmount,
        status: _statusFor(due: state.dueAmount, paid: state.amountPaid),
      );
      final invoiceItems = state.items
          .map((item) => InvoiceItemEntity(
                id: const Uuid().v4(),
                invoiceId: invoiceId,
                productId: item.id,
                name: item.name,
                qty: item.quantity ?? 0,
                price: item.sellingPrice,
                total: (item.quantity ?? 0) * item.sellingPrice,
              ))
          .toList();

      await ref
          .read(invoiceRepositoryProvider)
          .createInvoiceWithItems(invoice, invoiceItems);

      ref.invalidate(invoiceListProvider);
      return null;
    } catch (e, stack) {
      debugPrint('Error saving invoice: $e\n$stack');
      return 'Could not save invoice.';
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  String _generateInvoiceNo() =>
      'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

  String _statusFor({required double due, required double paid}) {
    if (due <= 0) return 'paid';
    if (paid > 0) return 'partial';
    return 'pending';
  }
}
