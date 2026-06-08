import 'package:get/get.dart';

import 'package:flutter_getx_app/features/business_setup/presentation/screens/business_setup_screen.dart';
import 'package:flutter_getx_app/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:flutter_getx_app/features/customer/presentation/screens/add_customer_screen.dart';
import 'package:flutter_getx_app/features/customer/presentation/screens/customer_details_screen.dart';
import 'package:flutter_getx_app/features/customer/presentation/screens/customer_list_screen.dart';
import 'package:flutter_getx_app/features/invoices/presentation/screens/create_invoice_screen.dart';
import 'package:flutter_getx_app/features/invoices/presentation/screens/invoice_details_screen.dart';
import 'package:flutter_getx_app/features/invoices/presentation/screens/invoice_list_screen.dart';

import 'package:flutter_getx_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:flutter_getx_app/features/add_payment/presentation/screens/add_payment_screen.dart';
import 'package:flutter_getx_app/features/due_payment/presentation/screens/due_payment_screen.dart';
import 'package:flutter_getx_app/features/product/presentation/screens/add_product_screen.dart';
import 'package:flutter_getx_app/features/product/presentation/screens/product_details_screen.dart';
import 'package:flutter_getx_app/features/product/presentation/screens/product_list_screen.dart';
import 'package:flutter_getx_app/features/backup_restore/presentation/screens/backup_restore_screen.dart';
import 'package:flutter_getx_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_getx_app/features/splash/presentation/screens/splash_screen.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.dashboard,
      page: () => const DashboardScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.invoices,
      page: () => const InvoiceListScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.createInvoice,
      page: () => const CreateInvoiceScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.invoiceDetails,
      page: () => const InvoiceDetailsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.businessSetup,
      page: () => const BusinessSetupScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.CUSTOMER_LIST,
      page: () => const CustomerListScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.CUSTOMER_DETAILS,
      page: () => const CustomerDetailsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.ADD_CUSTOMER,
      page: () => const AddCustomerScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.ADD_PRODUCT,
      page: () => const AddProductScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.PRODUCT_LIST,
      page: () => const ProductListScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => const ProductDetailsScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.BACKUP_RESTORE,
      page: () => const BackupRestoreScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.ADD_PAYMENT,
      page: () => const AddPaymentScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.DUE_PAYMENT,
      page: () => const DuePaymentScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
