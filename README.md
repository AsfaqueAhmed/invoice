# InvoiceFlow

A Flutter invoicing app scaffold built with GetX for routing, dependency injection, and state management.

## App Flow

The current user flow is:

1. `SplashView`
   - Animated InvoiceFlow launch screen.
   - Simulates app initialization.
   - Navigates to onboarding.

2. `OnboardingView`
   - Shows the InvoiceFlow introduction screen.
   - `Start Business` opens business setup.
   - `Restore Backup` is a placeholder for a future restore/import flow.

3. `BusinessSetupView`
   - Collects business name, phone number, address, currency, and optional logo.
   - Form submission is currently simulated.
   - Successful setup opens the dashboard.

4. `DashboardView`
   - Shows business summary cards, quick actions, recent invoices, FAB, and bottom navigation.
   - The `New Invoice` quick action opens invoice creation.
   - The `Invoices` tab and `See All` action open the invoice list.

5. `InvoiceListView`
   - Native Flutter version of the invoice list UI.
   - Includes search, status filters, receivable summary cards, invoice cards, swipe/tap card actions, FAB, and bottom navigation.
   - The FAB opens invoice creation.
   - Tapping an invoice opens invoice details.

6. `CreateInvoiceView`
   - Invoice creation form with customer selection, product search, line items, quantity controls, totals, discount, amount paid, due amount, and save/share/print actions.

7. `InvoiceDetailsView`
   - Paid invoice preview with status banner, invoice canvas, itemized table, payment summary, footer note, and share/print/edit/payment actions.

## Project Structure

The project follows a modular GetX-style structure:

- `lib/main.dart`: App entry point and `GetMaterialApp` setup.
- `lib/app/routes/`: Centralized route definitions.
- `lib/app/core/`: Theme, colors, text styles, spacing, and API constants.
- `lib/app/data/`: API providers and repositories.
- `lib/app/modules/`: Feature modules.

## Modules

### Splash

- View: `lib/app/modules/splash/view/splash_view.dart`
- Controller: `lib/app/modules/splash/controller/splash_controller.dart`
- Binding: `lib/app/modules/splash/binding/splash_binding.dart`

Note: there is also an older duplicate splash folder using plural names (`views`, `controllers`, `bindings`). The route currently uses the singular folder.

### Onboarding

- View: `lib/app/modules/onboarding/views/onboarding_view.dart`
- Controller: `lib/app/modules/onboarding/controllers/onboarding_controller.dart`
- Binding: `lib/app/modules/onboarding/bindings/onboarding_binding.dart`

### Business Setup

- View: `lib/app/modules/business_setup/views/business_setup_view.dart`
- Controller: `lib/app/modules/business_setup/controllers/business_setup_controller.dart`
- Binding: `lib/app/modules/business_setup/bindings/business_setup_binding.dart`

### Invoice List

- View: `lib/app/modules/invoice_list/views/invoice_list_view.dart`
- Controller: `lib/app/modules/invoice_list/controllers/invoice_list_controller.dart`
- Binding: `lib/app/modules/invoice_list/bindings/invoice_list_binding.dart`
- Model: `lib/app/modules/invoice_list/models/invoice_item.dart`

### Create Invoice

- View: `lib/app/modules/create_invoice/views/create_invoice_view.dart`
- Controller: `lib/app/modules/create_invoice/controllers/create_invoice_controller.dart`
- Binding: `lib/app/modules/create_invoice/bindings/create_invoice_binding.dart`
- Model: `lib/app/modules/create_invoice/models/create_invoice_item.dart`

### Invoice Details

- View: `lib/app/modules/invoice_details/views/invoice_details_view.dart`
- Controller: `lib/app/modules/invoice_details/controllers/invoice_details_controller.dart`
- Binding: `lib/app/modules/invoice_details/bindings/invoice_details_binding.dart`
- Model: `lib/app/modules/invoice_details/models/invoice_detail_item.dart`

### Dashboard

- View: `lib/app/modules/dashboard/views/dashboard_view.dart`
- Controller: `lib/app/modules/dashboard/controllers/dashboard_controller.dart`
- Binding: `lib/app/modules/dashboard/bindings/dashboard_binding.dart`
- Models: `lib/app/modules/dashboard/models/dashboard_summary.dart`

### Home

- View: `lib/app/modules/home/views/home_view.dart`
- Controller: `lib/app/modules/home/controllers/home_controller.dart`
- Binding: `lib/app/modules/home/bindings/home_binding.dart`

The home module is still mostly the default scaffold screen. The main product flow now lands on the dashboard after business setup.

## Routing

Routes are managed with GetX named routing:

- Initial route: `Routes.splash`
- `/splash`: Splash screen.
- `/onboarding`: Onboarding screen.
- `/business-setup`: Business setup form.
- `/dashboard`: Dashboard screen.
- `/invoices`: Invoice list screen.
- `/create-invoice`: Create invoice screen.
- `/invoice-details`: Invoice details screen.
- `/home`: Placeholder home screen.

Route registration lives in:

- `lib/app/routes/app_pages.dart`
- `lib/app/routes/app_routes.dart`

## Dependencies

- `get`: Routing, state management, and dependency injection.
- `http`: Network requests.
- `cached_network_image`: Cached image loading.

## Getting Started

Install dependencies:

```sh
flutter pub get
```

Run the app:

```sh
flutter run
```

Analyze the project:

```sh
flutter analyze
```

## Current Notes

- Business profile persistence is not implemented yet.
- Logo picking is a placeholder and needs an image picker integration.
- Dashboard data is currently static sample data in `DashboardController`.
- Invoice data is currently static sample data in `InvoiceListController`.
- Create invoice line items are currently static sample data in `CreateInvoiceController`.
- Invoice details are currently static sample data in `InvoiceDetailsController`.
- Dashboard and invoice bottom navigation have placeholder actions for modules that are not connected yet.
