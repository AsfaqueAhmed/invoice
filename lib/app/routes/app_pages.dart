import 'package:get/get.dart';

import '../modules/business_setup/bindings/business_setup_binding.dart';
import '../modules/business_setup/views/business_setup_view.dart';
import '../modules/customer/add_customer/bindings/add_customer_binding.dart';
import '../modules/customer/add_customer/views/add_customer_view.dart';
import '../modules/customer/customer_details/bindings/customer_details_binding.dart';
import '../modules/customer/customer_details/views/customer_details_view.dart';
import '../modules/customer/customer_list/bindings/customer_list_binding.dart';
import '../modules/customer/customer_list/views/customer_list_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/invoices/create_invoice/bindings/create_invoice_binding.dart';
import '../modules/invoices/create_invoice/views/create_invoice_view.dart';
import '../modules/invoices/invoice_details/bindings/invoice_details_binding.dart';
import '../modules/invoices/invoice_details/views/invoice_details_view.dart';
import '../modules/invoices/invoice_list/bindings/invoice_list_binding.dart';
import '../modules/invoices/invoice_list/views/invoice_list_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/payment/add_payment/bindings/add_payment_binding.dart';
import '../modules/payment/add_payment/views/add_payment_view.dart';
import '../modules/payment/due_payment/bindings/due_payment_binding.dart';
import '../modules/payment/due_payment/views/due_payment_view.dart';
import '../modules/product/add_product/bindings/add_product_binding.dart';
import '../modules/product/add_product/views/add_product_view.dart';
import '../modules/product/product_details/bindings/product_details_binding.dart';
import '../modules/product/product_details/views/product_details_view.dart';
import '../modules/product/product_list/bindings/product_list_binding.dart';
import '../modules/product/product_list/views/product_list_view.dart';
import '../modules/settings/backup_restore/bindings/backup_restore_binding.dart';
import '../modules/settings/backup_restore/views/backup_restore_view.dart';
import '../modules/settings/settings/bindings/settings_binding.dart';
import '../modules/settings/settings/views/settings_view.dart';
import '../modules/splash/binding/splash_binding.dart';
import '../modules/splash/view/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.invoices,
      page: () => const InvoiceListView(),
      binding: InvoiceListBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.createInvoice,
      page: () => const CreateInvoiceView(),
      binding: CreateInvoiceBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.invoiceDetails,
      page: () => const InvoiceDetailsView(),
      binding: InvoiceDetailsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.businessSetup,
      page: () => const BusinessSetupView(),
      binding: BusinessSetupBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.CUSTOMER_LIST,
      page: () => const CustomerListView(),
      binding: CustomerListBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.CUSTOMER_DETAILS,
      page: () => const CustomerDetailsView(),
      binding: CustomerDetailsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.ADD_CUSTOMER,
      page: () => const AddCustomerView(),
      binding: AddCustomerBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.ADD_PRODUCT,
      page: () => const AddProductView(),
      binding: AddProductBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.PRODUCT_LIST,
      page: () => const ProductListView(),
      binding: ProductListBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.BACKUP_RESTORE,
      page: () => const BackupRestoreView(),
      binding: BackupRestoreBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.ADD_PAYMENT,
      page: () => const AddPaymentView(),
      binding: AddPaymentBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.DUE_PAYMENT,
      page: () => const DuePaymentView(),
      binding: DuePaymentBinding(),
      transition: Transition.rightToLeft,
    ),
  ];
}
