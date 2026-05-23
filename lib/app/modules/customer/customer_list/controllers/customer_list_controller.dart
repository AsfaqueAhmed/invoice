import 'package:flutter_getx_app/app/modules/customer/customer_list/model/customer_model.dart';
import 'package:flutter_getx_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

class CustomerListController extends GetxController {
  final RxList<CustomerModel> customers = <CustomerModel>[].obs;
  final RxList<CustomerModel> filteredCustomers = <CustomerModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  @override
  void onInit() {
    _loadMockCustomers();
    ever(searchQuery, (_) => _filterCustomers());
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  void _loadMockCustomers() {
    isLoading.value = true;
    final mockData = [
      CustomerModel(
        id: '1',
        name: 'Jane Doe',
        phone: '+1 (555) 012-3456',
        email: 'jane@example.com',
        address: '123 Main St, New York, NY',
        status: CustomerStatus.active,
        totalPurchases: 24450,
        totalPaid: 23200,
        totalDue: 1250,
        lastInvoiceDate: DateTime(2023, 10, 24),
        overdueCount: 0,
        invoices: [
          InvoicePreview(
            invoiceNumber: 'INV-2024-081',
            amount: 3400,
            date: DateTime(2024, 3, 12),
            status: InvoiceStatus.overdue,
          ),
          InvoicePreview(
            invoiceNumber: 'INV-2024-074',
            amount: 2850,
            date: DateTime(2024, 2, 28),
            status: InvoiceStatus.paid,
          ),
          InvoicePreview(
            invoiceNumber: 'INV-2024-062',
            amount: 1200,
            date: DateTime(2024, 2, 15),
            status: InvoiceStatus.paid,
          ),
        ],
      ),
      CustomerModel(
        id: '2',
        name: 'Marcus Smith',
        phone: '+1 (555) 987-6543',
        status: CustomerStatus.newContract,
        totalPurchases: 0,
        totalPaid: 0,
        totalDue: 0,
        lastInvoiceDate: DateTime(2023, 11, 2),
      ),
      CustomerModel(
        id: '3',
        name: 'Aria Lopez',
        phone: '+1 (555) 246-8101',
        status: CustomerStatus.overdue,
        totalPurchases: 12000,
        totalPaid: 8579.50,
        totalDue: 3420.50,
        lastInvoiceDate: DateTime(2023, 10, 13),
        overdueCount: 2,
      ),
      CustomerModel(
        id: '4',
        name: 'David Chen',
        phone: '+1 (555) 777-8888',
        status: CustomerStatus.vip,
        totalPurchases: 45000,
        totalPaid: 45000,
        totalDue: 0,
        lastInvoiceDate: DateTime(2023, 10, 30),
      ),
      CustomerModel(
        id: '5',
        name: 'Sarah K.',
        phone: '+1 (555) 121-2121',
        status: CustomerStatus.inactive,
        totalPurchases: 5200,
        totalPaid: 4750,
        totalDue: 450,
        lastInvoiceDate: DateTime(2023, 9, 12),
      ),
    ];
    customers.assignAll(mockData);
    filteredCustomers.assignAll(mockData);
    isLoading.value = false;
  }

  void _filterCustomers() {
    if (searchQuery.value.isEmpty) {
      filteredCustomers.assignAll(customers);
    } else {
      final q = searchQuery.value.toLowerCase();
      filteredCustomers.assignAll(
        customers.where((c) =>
        c.name.toLowerCase().contains(q) ||
            c.phone.contains(q)),
      );
    }
  }

  void selectCustomer(CustomerModel customer) {
    Get.toNamed(Routes.CUSTOMER_DETAILS,arguments:  customer);
  }

  int get totalCustomers => customers.length;

  double get totalOverdue => customers.fold(0, (sum, c) => sum + c.totalDue);

  int get pendingCount => customers.where((c) => c.totalDue > 0).length;
}
