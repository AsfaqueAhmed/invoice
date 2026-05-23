import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/customer_details_controller.dart';

class CustomerDetailsView extends GetView<CustomerDetailsController> {
  const CustomerDetailsView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomerDetailsScreen();
  }
}

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({super.key});

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  int _currentNavIndex = 2; // Default highlighting the "Customers" tab

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideLayout = screenWidth > 768;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),

      // --- Top App Bar ---
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF8FF),
        elevation: 0,
        scrolledUnderElevation: 1,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF004AC6)),
          onPressed: () {},
        ),
        title: const Text(
          'InvoiceFlow',
          style: TextStyle(
            color: Color(0xFF004AC6),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF505F76)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),

      // --- Main View Content ---
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1024),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Profile Header
                _buildProfileHeader(isWideLayout),
                const SizedBox(height: 24),

                // 2. Financial Bento Grid
                _buildFinancialGrid(isWideLayout),
                const SizedBox(height: 24),

                // 3. Quick Actions
                _buildQuickActions(),
                const SizedBox(height: 32),

                // 4. Invoice History List
                _buildInvoiceHistory(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),

      // --- Bottom Navigation Bar ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 25,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _currentNavIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentNavIndex = index;
            });
          },
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFF2563EB).withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.description_outlined), label: 'Invoices'),
            NavigationDestination(icon: Icon(Icons.group, color: Color(0xFF004AC6)), label: 'Customers'),
            NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'Products'),
            NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
          ],
        ),
      ),
    );
  }

  // --- Profile Header Layout Component ---
  Widget _buildProfileHeader(bool isWide) {
    final avatarBlock = Stack(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 25, offset: const Offset(0, 10)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: Image.network(
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified, size: 16, color: Colors.white),
          ),
        ),
      ],
    );

    final infoBlock = Column(
      crossAxisAlignment: isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        const Text(
          'Alexander Sterling',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF191B23)),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: isWide ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: const [
            Icon(Icons.phone, size: 18, color: Color(0xFF434655)),
            SizedBox(width: 6),
            Text('+1 (555) 234-8901', style: TextStyle(fontSize: 14, color: Color(0xFF434655))),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: isWide ? MainAxisAlignment.start : MainAxisAlignment.center,
          children: const [
            Icon(Icons.location_on, size: 18, color: Color(0xFF434655)),
            SizedBox(width: 6),
            Text('822 Marble Arch Dr, San Francisco, CA', style: TextStyle(fontSize: 14, color: Color(0xFF434655))),
          ],
        ),
      ],
    );

    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          avatarBlock,
          const SizedBox(width: 24),
          Expanded(child: Padding(padding: const EdgeInsets.only(top: 8), child: infoBlock)),
        ],
      );
    }

    return Column(
      children: [
        avatarBlock,
        const SizedBox(height: 16),
        infoBlock,
      ],
    );
  }

  // --- Financial Bento Layout Grid Component ---
  Widget _buildFinancialGrid(bool isWide) {
    final elements = [
      _buildFinancialCard(
        title: 'Total Purchases',
        value: '\$24,450.00',
        icon: Icons.shopping_bag_outlined,
        iconColor: const Color(0xFF505F76),
        iconBg: const Color(0xFFEDEDF9),
      ),
      _buildFinancialCard(
        title: 'Total Paid',
        value: '\$18,200.00',
        icon: Icons.check_circle,
        iconColor: const Color(0xFF10B981),
        iconBg: const Color(0xFF10B981).withOpacity(0.1),
      ),
      _buildFinancialCard(
        title: 'Total Due',
        value: '\$6,250.00',
        icon: Icons.pending_actions,
        iconColor: Colors.white,
        iconBg: Colors.white.withOpacity(0.2),
        isPrimaryBg: true,
        badgeText: '2 Overdue',
      ),
    ];

    if (isWide) {
      return Row(
        children: elements.map((item) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: item))).toList(),
      );
    }

    return Column(
      children: elements.map((item) => Padding(padding: const EdgeInsets.only(bottom: 12), child: item)).toList(),
    );
  }

  Widget _buildFinancialCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    bool isPrimaryBg = false,
    String? badgeText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPrimaryBg ? const Color(0xFF2563EB) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: isPrimaryBg ? null : Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 25, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isPrimaryBg ? Colors.white.withOpacity(0.8) : const Color(0xFF505F76),
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isPrimaryBg ? Colors.white : const Color(0xFF191B23),
                  ),
                ),
              ],
            ),
          ),
          if (badgeText != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(99)),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(badgeText, style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500)),
                ],
              ),
            )
        ],
      ),
    );
  }

  // --- Quick Actions Bar Component ---
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Actions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF191B23))),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final double btnWidth = constraints.maxWidth > 600 ? (constraints.maxWidth - 32) / 3 : double.infinity;

            final actionButtons = [
              _buildActionButton(
                label: 'Call',
                icon: Icons.call_outlined,
                onPressed: () {},
                textColor: const Color(0xFF004AC6),
                bgColor: Colors.white,
                borderColor: const Color(0xFF004AC6).withOpacity(0.2),
              ),
              _buildActionButton(
                label: 'New Invoice',
                icon: Icons.add,
                onPressed: () {},
                textColor: Colors.white,
                bgColor: const Color(0xFF004AC6),
              ),
              _buildActionButton(
                label: 'Collect Payment',
                icon: Icons.payments_outlined,
                onPressed: () {},
                textColor: const Color(0xFF54647A),
                bgColor: const Color(0xFFD0E1FB),
              ),
            ];

            if (constraints.maxWidth > 600) {
              return Row(
                children: actionButtons.map((btn) => SizedBox(width: btnWidth, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: btn))).toList(),
              );
            }

            return Column(
              children: actionButtons.map((btn) => Padding(padding: const EdgeInsets.only(bottom: 12), child: btn)).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color textColor,
    required Color bgColor,
    Color? borderColor,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: borderColor != null ? Border.all(color: borderColor) : null,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
    );
  }

  // --- Invoice History Layout List Component ---
  Widget _buildInvoiceHistory() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Invoice History', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF191B23))),
            TextButton(
              onPressed: () {},
              child: Row(
                children: const [
                  Text('View All', style: TextStyle(color: Color(0xFF004AC6), fontWeight: FontWeight.w600)),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 16, color: Color(0xFF004AC6)),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 12),
        _buildInvoiceListItem(
          id: 'Invoice #INV-2024-081',
          date: 'March 12, 2024',
          amount: '\$3,400.00',
          status: 'Overdue',
          statusColor: const Color(0xFFBA1A1A),
          statusBg: const Color(0xFFFFDAD6).withOpacity(0.4),
        ),
        const SizedBox(height: 12),
        _buildInvoiceListItem(
          id: 'Invoice #INV-2024-074',
          date: 'Feb 28, 2024',
          amount: '\$2,850.00',
          status: 'Paid',
          statusColor: const Color(0xFF10B981),
          statusBg: const Color(0xFF10B981).withOpacity(0.1),
        ),
        const SizedBox(height: 12),
        _buildInvoiceListItem(
          id: 'Invoice #INV-2024-062',
          date: 'Feb 15, 2024',
          amount: '\$1,200.00',
          status: 'Paid',
          statusColor: const Color(0xFF10B981),
          statusBg: const Color(0xFF10B981).withOpacity(0.1),
        ),
      ],
    );
  }

  Widget _buildInvoiceListItem({
    required String id,
    required String date,
    required String amount,
    required String status,
    required Color statusColor,
    required Color statusBg,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 25, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF3F3FE), borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.description_outlined, color: Color(0xFF505F76)),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(id, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF191B23))),
                  const SizedBox(height: 4),
                  Text(date, style: const TextStyle(fontSize: 14, color: Color(0xFF434655))),
                ],
              )
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF191B23))),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(99)),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor, letterSpacing: 0.5),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
