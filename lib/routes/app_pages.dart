import 'package:get/get.dart';

import 'package:flutter_getx_app/features/splash/presentation/bindings/splash_binding.dart';
import 'package:flutter_getx_app/features/splash/presentation/views/splash_view.dart';

import 'package:flutter_getx_app/features/onboarding/presentation/bindings/onboarding_binding.dart';
import 'package:flutter_getx_app/features/onboarding/presentation/views/onboarding_view.dart';

import 'package:flutter_getx_app/features/business/presentation/bindings/business_setup_binding.dart';
import 'package:flutter_getx_app/features/business/presentation/views/business_setup_view.dart';

import 'package:flutter_getx_app/features/dashboard/presentation/bindings/dashboard_binding.dart';
import 'package:flutter_getx_app/features/dashboard/presentation/views/dashboard_view.dart';

import 'package:flutter_getx_app/features/invoice/presentation/bindings/invoice_list_binding.dart';
import 'package:flutter_getx_app/features/invoice/presentation/views/invoice_list_view.dart';
import 'package:flutter_getx_app/features/invoice/presentation/bindings/create_invoice_binding.dart';
import 'package:flutter_getx_app/features/invoice/presentation/views/create_invoice_view.dart';
import 'package:flutter_getx_app/features/invoice/presentation/bindings/invoice_details_binding.dart';
import 'package:flutter_getx_app/features/invoice/presentation/views/invoice_details_view.dart';

import 'package:flutter_getx_app/features/customer/presentation/bindings/customer_list_binding.dart';
import 'package:flutter_getx_app/features/customer/presentation/views/customer_list_view.dart';
import 'package:flutter_getx_app/features/customer/presentation/bindings/add_customer_binding.dart';
import 'package:flutter_getx_app/features/customer/presentation/views/add_customer_view.dart';
import 'package:flutter_getx_app/features/customer/presentation/bindings/customer_details_binding.dart';
import 'package:flutter_getx_app/features/customer/presentation/views/customer_details_view.dart';

import 'package:flutter_getx_app/features/product/presentation/bindings/product_list_binding.dart';
import 'package:flutter_getx_app/features/product/presentation/views/product_list_view.dart';
import 'package:flutter_getx_app/features/product/presentation/bindings/add_product_binding.dart';
import 'package:flutter_getx_app/features/product/presentation/views/add_product_view.dart';
import 'package:flutter_getx_app/features/product/presentation/bindings/product_details_binding.dart';
import 'package:flutter_getx_app/features/product/presentation/views/product_details_view.dart';

import 'package:flutter_getx_app/features/payment/presentation/bindings/add_payment_binding.dart';
import 'package:flutter_getx_app/features/payment/presentation/views/add_payment_view.dart';
import 'package:flutter_getx_app/features/payment/presentation/bindings/due_payment_binding.dart';
import 'package:flutter_getx_app/features/payment/presentation/views/due_payment_view.dart';

import 'package:flutter_getx_app/features/settings/presentation/bindings/settings_binding.dart';
import 'package:flutter_getx_app/features/settings/presentation/views/settings_view.dart';
import 'package:flutter_getx_app/features/settings/presentation/bindings/backup_restore_binding.dart';
import 'package:flutter_getx_app/features/settings/presentation/views/backup_restore_view.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.businessSetup,
      page: () => const BusinessSetupView(),
      binding: BusinessSetupBinding(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),

    // ── Invoices ──────────────────────────────────────────────
    GetPage(
      name: Routes.invoices,
      page: () => const InvoiceListView(),
      binding: InvoiceListBinding(),
    ),
    GetPage(
      name: Routes.createInvoice,
      page: () => const CreateInvoiceView(),
      binding: CreateInvoiceBinding(),
    ),
    GetPage(
      name: Routes.invoiceDetails,
      page: () => const InvoiceDetailsView(),
      binding: InvoiceDetailsBinding(),
    ),

    // ── Customers ─────────────────────────────────────────────
    GetPage(
      name: Routes.customers,
      page: () => const CustomerListView(),
      binding: CustomerListBinding(),
    ),
    GetPage(
      name: Routes.addCustomer,
      page: () => const AddCustomerView(),
      binding: AddCustomerBinding(),
    ),
    GetPage(
      name: Routes.customerDetails,
      page: () => const CustomerDetailsView(),
      binding: CustomerDetailsBinding(),
    ),

    // ── Products ──────────────────────────────────────────────
    GetPage(
      name: Routes.products,
      page: () => const ProductListView(),
      binding: ProductListBinding(),
    ),
    GetPage(
      name: Routes.addProduct,
      page: () => const AddProductView(),
      binding: AddProductBinding(),
    ),
    GetPage(
      name: Routes.productDetails,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),

    // ── Payments ──────────────────────────────────────────────
    GetPage(
      name: Routes.addPayment,
      page: () => const AddPaymentView(),
      binding: AddPaymentBinding(),
    ),
    GetPage(
      name: Routes.duePayment,
      page: () => const DuePaymentView(),
      binding: DuePaymentBinding(),
    ),

    // ── Settings ──────────────────────────────────────────────
    GetPage(
      name: Routes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: Routes.backupRestore,
      page: () => const BackupRestoreView(),
      binding: BackupRestoreBinding(),
    ),
  ];
}
