part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const splash = _Paths.splash;
  static const onboarding = _Paths.onboarding;
  static const businessSetup = _Paths.businessSetup;
  static const home = _Paths.home;
  static const invoices = _Paths.invoices;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const CUSTOMER_LIST = _Paths.CUSTOMER_LIST;
  static const CUSTOMER_ADD = _Paths.CUSTOMER_ADD;
  static const CUSTOMER_DETAILS = _Paths.CUSTOMER_DETAILS;
}

abstract class _Paths {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const businessSetup = '/business-setup';
  static const home = '/home';
  static const invoices = '/invoices';
  static const ONBOARDING = '/onboarding';
  static const CUSTOMER_LIST = '/customer-list';
  static const CUSTOMER_ADD = '/customer-add';
  static const CUSTOMER_DETAILS = '/customer-details';
}
