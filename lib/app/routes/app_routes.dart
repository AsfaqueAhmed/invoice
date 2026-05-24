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

  // static const CUSTOMER_LIST = _Paths.CUSTOMER_LIST;
  // static const CUSTOMER_ADD = _Paths.CUSTOMER_ADD;
  // static const CUSTOMER_DETAILS = _Paths.CUSTOMER_DETAILS;
  static const CUSTOMER_LIST = _Paths.CUSTOMER_LIST;
  static const CUSTOMER_DETAILS = _Paths.CUSTOMER_DETAILS;
  static const ADD_CUSTOMER = _Paths.ADD_CUSTOMER;
  static const PRODUCT_LIST = _Paths.PRODUCT_LIST;
  static const ADD_PRODUCT = _Paths.ADD_PRODUCT;
  static const PRODUCT_DETAILS = _Paths.PRODUCT_DETAILS;
  static const CUSTOMERS = _Paths.CUSTOMERS;
  static const SETTINGS = _Paths.SETTINGS;
  static const BACKUP_RESTORE = _Paths.BACKUP_RESTORE;
  static const ADD_PAYMENT = _Paths.ADD_PAYMENT;
  static const DUE_PAYMENT = _Paths.DUE_PAYMENT;
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
  static const ADD_CUSTOMER = '/add-customer';
  static const ADD_PRODUCT = '/add-product';
  static const PRODUCT_LIST = '/product-list';
  static const PRODUCT_DETAILS = '/product-details';
  static const CUSTOMER_LIST = '/customer-list';
  static const CUSTOMER_DETAILS = '/customer-details';
  static const CUSTOMERS = '/customers';
  static const SETTINGS = '/settings';
  static const BACKUP_RESTORE = '/backup-restore';
  static const ADD_PAYMENT = '/add-payment';
  static const DUE_PAYMENT = '/due-payment';
}
