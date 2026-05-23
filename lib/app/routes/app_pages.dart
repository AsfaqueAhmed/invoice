import 'package:get/get.dart';

import '../modules/business_setup/bindings/business_setup_binding.dart';
import '../modules/business_setup/views/business_setup_view.dart';
import '../modules/customer/add_customer/bindings/add_customer_binding.dart';
import '../modules/customer/add_customer/views/add_customer_view.dart';
import '../modules/customer/customer_details/bindings/customer_details_binding.dart';
import '../modules/customer/customer_details/views/customer_details_view.dart';
import '../modules/customer/customer_list/bindings/customer_list_binding.dart';
import '../modules/customer/customer_list/views/customer_list_view.dart';
import '../modules/customer_add/bindings/customer_add_binding.dart';
import '../modules/customer_add/views/customer_add_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/invoice_list/bindings/invoice_list_binding.dart';
import '../modules/invoice_list/views/invoice_list_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/product/add_product/bindings/add_product_binding.dart';
import '../modules/product/add_product/views/add_product_view.dart';
import '../modules/product/product_details/bindings/product_details_binding.dart';
import '../modules/product/product_details/views/product_details_view.dart';
import '../modules/product/product_list/bindings/product_list_binding.dart';
import '../modules/product/product_list/views/product_list_view.dart';
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
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.invoices,
      page: () => const InvoiceListView(),
      binding: InvoiceListBinding(),
      transition: Transition.fadeIn,
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
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMER_LIST,
      page: () => const CustomerListView(),
      binding: CustomerListBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMER_ADD,
      page: () => const CustomerAddView(),
      binding: CustomerAddBinding(),
    ),
    GetPage(
      name: _Paths.CUSTOMER_DETAILS,
      page: () => const CustomerDetailsView(),
      binding: CustomerDetailsBinding(),
    ),
    GetPage(
      name: _Paths.ADD_CUSTOMER,
      page: () => const AddCustomerView(),
      binding: AddCustomerBinding(),
    ),
    GetPage(
      name: _Paths.ADD_PRODUCT,
      page: () => const AddProductView(),
      binding: AddProductBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_LIST,
      page: () => const ProductListView(),
      binding: ProductListBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAILS,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
  ];
}
