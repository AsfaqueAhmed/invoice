import 'package:flutter/material.dart';
import 'package:flutter_getx_app/app/core/configs/theme/app_color.dart';
import 'package:flutter_getx_app/app/core/widgets/app_bottom_nav.dart';
import 'package:flutter_getx_app/app/core/widgets/app_card.dart';
import 'package:flutter_getx_app/app/core/widgets/status_badge.dart';
import 'package:flutter_getx_app/app/modules/invoices/invoice_list/controllers/invoice_list_controller.dart';
import 'package:get/get.dart';

class InvoiceListView extends GetView<InvoiceListController> {
  const InvoiceListView({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: controller.onCreateInvoice,
          child: const Icon(Icons.add_rounded, size: 28)),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: CustomScrollView(slivers: [
        SliverAppBar(
          floating: true,
          snap: true,
          pinned: false,
          backgroundColor: isDark ? AppColor.darkSurface : AppColor.surface,
          elevation: 0,
          title: Text('Invoices',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: cs.primary)),
          actions: [
            IconButton(
                icon: Icon(Icons.search_rounded, color: cs.onSurfaceVariant),
                onPressed: () {}),
            IconButton(
                icon: Icon(Icons.notifications_outlined,
                    color: cs.onSurfaceVariant),
                onPressed: () {}),
          ],
        ),
        SliverToBoxAdapter(
            child: Column(children: [
          // Search
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: TextField(
                  controller: controller.searchController,
                  onChanged: controller.onSearch,
                  decoration: const InputDecoration(
                      hintText: 'Search by number or name...',
                      prefixIcon: Icon(Icons.search_rounded),
                      suffixIcon: Icon(Icons.tune_rounded),
                      contentPadding: EdgeInsets.symmetric(vertical: 14)))),
          // Filter chips
          SizedBox(
              height: 56,
              child: Obx(() => ListView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  children: controller.filters.map((f) {
                    final active = controller.selectedFilter.value == f;
                    return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                            onTap: () => controller.onFilter(f),
                            child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                    color: active
                                        ? cs.primary
                                        : cs.surfaceContainerHigh,
                                    borderRadius: BorderRadius.circular(99)),
                                child: Text(f,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: active
                                            ? cs.onPrimary
                                            : cs.onSurfaceVariant)))));
                  }).toList()))),
          // Stats
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Row(children: [
                Expanded(
                    child: AppCard(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                      Text('Total Receivable',
                          style: TextStyle(
                              fontSize: 11,
                              color: cs.secondary,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(controller.totalReceivable,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface)),
                    ]))),
                const SizedBox(width: 12),
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  color: cs.primary.withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4))
                            ]),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Collected (MTD)',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: cs.onPrimaryContainer
                                          .withOpacity(0.8),
                                      fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(controller.collectedMTD,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: cs.onPrimaryContainer)),
                            ]))),
              ])),
          // Invoice list
          Obx(() {
            final list = controller.filtered;
            return Column(
                children: list
                    .map((inv) => Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5),
                          child: AppCard(
                              onTap: () => controller.onInvoiceTap(inv),
                              child: Row(children: [
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(
                                          '#${inv['number']}  •  ${inv['date']}',
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: cs.secondary)),
                                      const SizedBox(height: 4),
                                      Text(inv['client'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15)),
                                      const SizedBox(height: 6),
                                      Row(children: [
                                        Container(
                                            width: 8,
                                            height: 8,
                                            margin:
                                                const EdgeInsets.only(right: 6),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: _statusColor(
                                                    inv['status'], cs))),
                                        StatusBadge(
                                            status: StatusBadge.fromString(
                                                inv['status'])),
                                      ]),
                                    ])),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(inv['amount'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                              color: cs.primary)),
                                      const SizedBox(height: 4),
                                      Text(inv['tag'],
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: cs.secondary)),
                                    ]),
                              ])),
                        ))
                    .toList());
          }),
          const SizedBox(height: 100),
        ])),
      ]),
    );
  }

  Color _statusColor(String s, ColorScheme cs) {
    switch (s) {
      case 'paid':
        return AppColor.successText;
      case 'partial':
        return AppColor.warningText;
      case 'overdue':
        return cs.error;
      default:
        return AppColor.warningText;
    }
  }
}
