part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const splash = _Paths.splash;
  static const onboarding = _Paths.onboarding;
  static const businessSetup = _Paths.businessSetup;
  static const home = _Paths.home;
  static const dashboard = _Paths.dashboard;
  static const invoices = _Paths.invoices;
  static const createInvoice = _Paths.createInvoice;
  static const invoiceDetails = _Paths.invoiceDetails;
  static const ONBOARDING = _Paths.ONBOARDING;
}

abstract class _Paths {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const businessSetup = '/business-setup';
  static const home = '/home';
  static const dashboard = '/dashboard';
  static const invoices = '/invoices';
  static const createInvoice = '/create-invoice';
  static const invoiceDetails = '/invoice-details';
  static const ONBOARDING = '/onboarding';
}
