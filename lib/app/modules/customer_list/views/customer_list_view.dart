import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/configs/text_style/app_text_styles.dart';
import '../../../core/configs/theme/app_colors.dart';
import '../../../core/constants/gaps.dart';
import '../controllers/customer_list_controller.dart';

class CustomerListView extends GetView<CustomerListController> {
  const CustomerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomersDashboard();
  }
}

class CustomersDashboard extends StatefulWidget {
  const CustomersDashboard({super.key});

  @override
  State<CustomersDashboard> createState() => _CustomersDashboardState();
}

class _CustomersDashboardState extends State<CustomersDashboard> {
  int _currentNavIndex = 2; // Default to 'Customers' tab as in HTML

  @override
  Widget build(BuildContext context) {
    // Handling responsive constraints manually for adaptive grid rendering
    final double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 1;
    if (screenWidth >= 1024) {
      crossAxisCount = 3;
    } else if (screenWidth >= 640) {
      crossAxisCount = 2;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      // --- TopAppBar ---
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8FF),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            Icon(Icons.account_balance_wallet_outlined,
                color: Theme.of(context).primaryColor),
            const SizedBox(width: 12),
            Text(
              'InvoiceFlow',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),

      // --- Main Contents ---
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            // Max-width 7xl layout
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Search Bar Section
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by name or phone...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 2. Bento Box Style Stats Section
                LayoutBuilder(
                  builder: (context, constraints) {
                    bool isWide = constraints.maxWidth > 768;
                    return Flex(
                      direction: isWide ? Axis.horizontal : Axis.vertical,
                      children: [
                        Expanded(
                          flex: isWide ? 1 : 0,
                          child: const StatCard(
                            title: "TOTAL CUSTOMERS",
                            value: "128",
                            subValue: "+12% this month",
                            isErrorType: false,
                          ),
                        ),
                        SizedBox(
                            width: isWide ? 16 : 0, height: isWide ? 0 : 16),
                        Expanded(
                          flex: isWide ? 1 : 0,
                          child: const StatCard(
                            title: "TOTAL OVERDUE",
                            value: "\$14,240",
                            subValue: "24 Pending",
                            isErrorType: true,
                          ),
                        ),
                        if (isWide) ...[
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 96,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0044AC6),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Business Growth",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          "You've added 14 new customers.",
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.white.withOpacity(0.2),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                    ),
                                    child: const Text("Reports",
                                        style: TextStyle(color: Colors.white)),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]
                      ],
                    );
                  },
                ),
                const SizedBox(height: 28),

                // 3. Section Title Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Active Customers',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF191B23)),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list,
                          size: 18, color: Color(0xFF0044AC6)),
                      label: const Text('Filter',
                          style: TextStyle(color: Color(0xFF0044AC6))),
                    )
                  ],
                ),
                const SizedBox(height: 16),

                // 4. Grid System containing Client Cards & Call to Action Placeholders
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  // 5 profiles + 1 add card template layout
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 190,
                  ),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return const CustomerCard(
                        initials: "JD",
                        name: "Jane Doe",
                        phone: "+1 (555) 012-3456",
                        lastInvoice: "Oct 24, 2023",
                        statusText: "Active Account",
                        statusColor: Color(0xFF047857),
                        statusBg: Color(0xFFE6F4EA),
                        dueAmount: "\$1,250.00",
                        isAmountError: true,
                      );
                    } else if (index == 1) {
                      return const CustomerCard(
                        initials: "MS",
                        name: "Marcus Smith",
                        phone: "+1 (555) 987-6543",
                        lastInvoice: "Nov 02, 2023",
                        statusText: "New Contract",
                        statusColor: Color(0xFF0044AC6),
                        statusBg: Color(0xFFE8F0FE),
                        dueAmount: "\$0.00",
                        isAmountError: false,
                      );
                    } else if (index == 2) {
                      return const CustomerCard(
                        initials: "AL",
                        name: "Aria Lopez",
                        phone: "+1 (555) 246-8101",
                        lastInvoice: "Oct 15, 2023",
                        statusText: "Overdue 14 Days",
                        statusColor: Color(0xFFBA1A1A),
                        statusBg: Color(0xFFFFDAD6),
                        dueAmount: "\$3,420.50",
                        isAmountError: true,
                      );
                    } else if (index == 3) {
                      return const CustomerCard(
                        name: "David Chen",
                        phone: "+1 (555) 777-8888",
                        lastInvoice: "Oct 30, 2023",
                        statusText: "VIP Customer",
                        statusColor: Color(0xFF047857),
                        statusBg: Color(0xFFE6F4EA),
                        dueAmount: "\$0.00",
                        isAmountError: false,
                        avatarUrl:
                            "https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&w=100&q=80", // Premium network fallback profile asset
                      );
                    } else if (index == 4) {
                      return const CustomerCard(
                        initials: "SK",
                        name: "Sarah K.",
                        phone: "+1 (555) 121-2121",
                        lastInvoice: "Sep 12, 2023",
                        statusText: "Inactive (30d+)",
                        statusColor: Color(0xFF505F76),
                        statusBg: Color(0xFFEDF0F5),
                        dueAmount: "\$450.00",
                        isAmountError: true,
                      );
                    } else {
                      // Placeholder dynamic layout component built for action requests
                      return const AddNewCustomerCard();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper Widget: Statistical Overview Component
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subValue;
  final bool isErrorType;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subValue,
    required this.isErrorType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isErrorType
            ? const Color(0xFFFFDAD6).withOpacity(0.3)
            : const Color(0xFFEDEDF9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isErrorType
              ? const Color(0xFFBA1A1A).withOpacity(0.1)
              : const Color(0xFFC3C6D7).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isErrorType
                      ? const Color(0xFFBA1A1A)
                      : const Color(0xFF505F76))),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isErrorType
                          ? const Color(0xFFBA1A1A)
                          : const Color(0xFF0044AC6))),
              const SizedBox(width: 8),
              Text(subValue,
                  style: TextStyle(
                      fontSize: 12,
                      color: isErrorType
                          ? const Color(0xFFBA1A1A).withOpacity(0.6)
                          : const Color(0xFF0044AC6).withOpacity(0.6))),
            ],
          )
        ],
      ),
    );
  }
}

// Helper Widget: Dynamic Interactive Profile Block
class CustomerCard extends StatefulWidget {
  final String? initials;
  final String name;
  final String phone;
  final String lastInvoice;
  final String statusText;
  final Color statusColor;
  final Color statusBg;
  final String dueAmount;
  final bool isAmountError;
  final String? avatarUrl;

  const CustomerCard({
    super.key,
    this.initials,
    required this.name,
    required this.phone,
    required this.lastInvoice,
    required this.statusText,
    required this.statusColor,
    required this.statusBg,
    required this.dueAmount,
    required this.isAmountError,
    this.avatarUrl,
  });

  @override
  State<CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  bool _isHovered = false; // Mimics microinteractions TranslateY logic cleanly

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerListController>();
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: controller.onCustomerCardTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
                color: _isHovered
                    ? const Color(0xFF0044AC6).withOpacity(0.2)
                    : const Color(0xFFE1E2ED).withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 8)),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Render network image profile if url exists, fallback to parsed initials avatar block
                  widget.avatarUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(widget.avatarUrl!,
                              width: 48, height: 48, fit: BoxFit.cover),
                        )
                      : Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                              color: const Color(0xFFDBE1FF),
                              borderRadius: BorderRadius.circular(16)),
                          alignment: Alignment.center,
                          child: Text(widget.initials ?? "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0044AC6),
                                  fontSize: 16)),
                        ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF191B23)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                        Text(widget.phone,
                            style: const TextStyle(
                                color: Color(0xFF505F76), fontSize: 13)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert, color: Colors.grey),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("LAST INVOICE",
                          style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF505F76),
                              fontWeight: FontWeight.w600)),
                      Text(widget.lastInvoice,
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: widget.statusBg,
                            borderRadius: BorderRadius.circular(999)),
                        child: Text(widget.statusText,
                            style: TextStyle(
                                color: widget.statusColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text("DUE AMOUNT",
                          style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF505F76),
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      Text(
                        widget.dueAmount,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: widget.isAmountError
                              ? const Color(0xFFBA1A1A)
                              : const Color(0xFF191B23),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Helper Widget: Dashed Button Template Placeholder Block
class AddNewCustomerCard extends StatelessWidget {
  const AddNewCustomerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CustomerListController>();
    return InkWell(
      onTap: controller.onAddNewCustomerTap,
      borderRadius: BorderRadius.circular(24),
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: const Color(0xFFC3C6D7),
          strokeWidth: 2,
          dashWidth: 6,
          dashSpace: 4,
          borderRadius: 24,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          alignment: Alignment.center,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFFEDEDF9),
                child: Icon(Icons.add, color: Color(0xFF737686)),
              ),
              SizedBox(height: 12),
              Text(
                "Add New Customer",
                style: TextStyle(
                  color: Color(0xFF737686),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// Custom Painter to cleanly draw a rounded dashed/dotted rectangle border
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 2,
    this.dashWidth = 6,
    this.dashSpace = 4,
    this.borderRadius = 24,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Create a rounded rectangle path matching your card shape
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);

    // Animate or parse the path to convert solid lines into intervals
    final Path dashedPath = Path();
    double distance = 0.0;

    for (final PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
