import 'package:flutter_getx_app/app/core/extensions/num_extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../domain/entities/customer_entity.dart';

/// Search query typed into the customer list search field.
final customerSearchQueryProvider = StateProvider<String>((ref) => '');

/// Loads all customers and keeps the list in sync after creates/updates.
final customerListProvider =
    AsyncNotifierProvider<CustomerListNotifier, List<CustomerEntity>>(
  CustomerListNotifier.new,
);

class CustomerListNotifier extends AsyncNotifier<List<CustomerEntity>> {
  @override
  Future<List<CustomerEntity>> build() {
    return ref.watch(customerRepositoryProvider).getAll();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(customerRepositoryProvider).getAll(),
    );
  }
}

/// Customers filtered by the current search query (matches name or phone).
final filteredCustomersProvider = Provider<List<CustomerEntity>>((ref) {
  final customers = ref.watch(customerListProvider).valueOrNull ?? [];
  final query = ref.watch(customerSearchQueryProvider).toLowerCase().trim();
  if (query.isEmpty) return customers;
  return customers
      .where((c) =>
          c.name.toLowerCase().contains(query) || c.phone.contains(query))
      .toList();
});

/// Total number of customers, for the stats header.
final totalCustomersProvider = Provider<int>((ref) {
  return (ref.watch(customerListProvider).valueOrNull ?? []).length;
});

/// Sum of every customer's outstanding balance, formatted as currency.
final totalCustomerOverdueProvider = Provider<String>((ref) {
  final customers = ref.watch(customerListProvider).valueOrNull ?? [];
  final total = customers.fold<double>(0, (sum, c) => sum + c.totalDue);
  return total.asCurrency;
});
