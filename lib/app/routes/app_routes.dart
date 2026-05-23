part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const splash = _Paths.splash;
  static const onboarding = _Paths.onboarding;
  static const businessSetup = _Paths.businessSetup;
  static const home = _Paths.home;
  static const ONBOARDING = _Paths.ONBOARDING;
}

abstract class _Paths {
  static const splash = '/splash';
  static const onboarding = '/onboarding';
  static const businessSetup = '/business-setup';
  static const home = '/home';
  static const ONBOARDING = '/onboarding';
}
