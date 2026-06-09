import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_getx_app/core/extensions/string_extensions.dart';
import 'package:flutter_getx_app/features/customer/domain/models/customer.dart';
import 'package:get/get.dart';

class SelectCustomerBottomSheet extends StatelessWidget {
  final List<Customer> customers;
  final Customer? selectedCustomer;
  final void Function(Customer) onSelect;
  final VoidCallback onAddTap;

  const SelectCustomerBottomSheet({
    super.key,
    required this.customers,
    required this.selectedCustomer,
    required this.onSelect,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      builder: (context, scrollController) {
        final theme = Theme.of(context);
        final cs = theme.colorScheme;

        return Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: cs.outlineVariant,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('Select Customer',
                        style: theme.textTheme.titleLarge),
                    const Spacer(),
                    IconButton(
                      onPressed: Get.back,
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              // Add new customer action
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: InkWell(
                  onTap: onAddTap,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: cs.primaryContainer),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person_add_alt, color: cs.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add New Customer',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: cs.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Create a new customer profile',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  controller: scrollController,
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final customer = customers[index];
                    final selected = customer.id == selectedCustomer?.id;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      child: InkWell(
                        onTap: () => onSelect(customer),
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selected ? cs.primaryContainer : cs.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected ? cs.primary : cs.outlineVariant,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: cs.surfaceContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: customer.avatar != null &&
                                        customer.avatar!.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(1000),
                                        child: Image.file(
                                          File(customer.avatar!),
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Text(
                                        customer.name.initials,
                                        style: theme.textTheme.labelLarge,
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(customer.name,
                                        style: theme.textTheme.titleMedium),
                                    const SizedBox(height: 4),
                                    Text(
                                      customer.phone,
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              if (selected)
                                Icon(Icons.check_circle, color: cs.primary),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
