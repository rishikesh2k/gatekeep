# GateKeep - Visitor Management App

A Flutter Android app for front-desk and security staff to register visitors, generate and scan visitor QR codes, and record check-in / check-out. All data is stored on a mock REST API (MockAPI.io).

---

## 1. Features

| Area | What it does |
|------|--------------|
| Dashboard | Total Visitors Today, Currently Checked In and Checked Out Today cards, plus Register / Scan / Visitor List shortcuts. Pull to refresh. |
| Register / Edit | Form with validation (name required, 10-digit mobile, optional email, type and project dropdowns, purpose required). Shows a confirmation dialog with the QR code after registering. |
| Visitor List | Search by name or mobile, filter by status, pull to refresh, edit and delete (with confirmation), tap a card to open details. |
| Visitor Details | Profile card, QR code, status chip, check-in / check-out button, timestamps. |
| QR Scanner | Camera preview with a scan box. Validates the QR, looks the visitor up from the API, then opens details. Handles invalid QR codes, unknown visitors, repeated scans and denied camera permission. |
| Status workflow | `Registered → Checked In → Checked Out`, enforced before every update. |
| Offline data | Works without the mock API using dummy data saved in shared preferences. |
| Extras | Status filter, pull-to-refresh, recent visitors on the dashboard, dark mode (follows the system), unit tests. |

---

## 2. Versions

| Tool | Version |
|------|---------|
| Flutter | 3.44.3 (stable) |
| Dart | 3.12.2 |
| Platform | Android (minSdk from Flutter defaults, `mobile_scanner` needs 23+) |

---

## 3. Packages

| Package | Why |
|---------|-----|
| `provider` | State management (`ChangeNotifier` + `Selector`) |
| `get_it` | Service locator (`locator.dart`) for services and page providers |
| `dio` | REST API calls (`DioClient` wrapper, same as Iron Compliance) |
| `shared_preferences` | Local visitor data when the mock API is not connected |
| `qr_flutter` | Generate the visitor QR code |
| `mobile_scanner` | Scan QR codes with the camera |
| `intl` | Date formatting |

---


## 3. Run the project

```bash
flutter pub get

flutter run
```

Build the APK:

```bash
flutter build apk --release
# output: build/app/outputs/flutter-apk/app-release.apk
```

Run tests:

```bash
flutter test
```

---

## 4. Project structure

The app uses the same structure as our other projects (Iron Compliance): **locator + router + BaseView / BaseSelector / BaseProvider**, with one provider per page.

```
lib/
├── main.dart                 setUpLocator(), MaterialApp with navigatorKey and onGenerateRoute
├── locator.dart              GetIt registrations
├── router.dart               Route name → page
├── model/                    visitor.dart, visitor_status.dart
├── services/
│   ├── api_service.dart      All API calls, falls back to local data
│   ├── local_data_service.dart  Visitors in shared preferences (dummy data)
│   ├── api_exception.dart
│   ├── visitor_store.dart    Shared visitor list (single source of truth)
│   └── navigation_service.dart
├── provider/
│   ├── base_provider.dart    busy / runBusy / customNotify, listens to VisitorStore
│   ├── home_provider.dart    dashboard_provider.dart   visitor_list_provider.dart
│   ├── visitor_form_provider.dart   visitor_details_provider.dart   qr_scanner_provider.dart
├── view/
│   ├── base_view.dart        base_selector.dart
│   ├── home/  dashboard/  visitor_list/  visitor_form/  visitor_details/  qr_scanner/
├── helper/                   dio_client, shared_prefs, validators, date_helper, qr_helper, app_message
├── utils/                    api_constants, app_colors, app_constants, app_routes, app_theme,
│                             app_dimensions, dummy_visitors
└── widgets/                  CustomButton, CustomTextField, CustomDropdown, DashboardStatCard,
                              VisitorCard, StatusChip, LoadingView, EmptyStateWidget, InfoRow,
                              VisitorQrCode, VisitorAvatar, QuickActionTile, LocalDataBanner,
                              AppConfirmDialog
test/                         Model, validator, provider and local data tests
```

Data flow: **Page → page provider → ApiService → MockAPI**. The provider then updates `VisitorStore`, and the store notifies every open page. Pages never call Dio and contain no business logic.

---

## 5. State management: Provider + BaseView / BaseSelector

- **`locator.dart` (GetIt)**: `ApiService` and `VisitorStore` are lazy singletons (one for the whole app). Each page provider is a factory, so every page gets a new one.
- **`BaseView<T>`** creates the page provider from the locator, calls `onModelReady` to pass the page arguments, provides it with `ChangeNotifierProvider.value`, and disposes it when the page closes.
- **`BaseSelector<T, V>`** wraps `Selector`, so only the part whose selected value changed is rebuilt (for example only the Save button when `busy` changes).
- **`BaseProvider`** gives every provider `api`, `store`, `busy` / `runBusy` and a safe `customNotify`. It also **listens to `VisitorStore`**, so when any page changes a visitor (register, edit, delete, check-in, check-out), the dashboard, list and details all rebuild with the new data, with no restart and no extra reload.
- Dashboard counts are getters on the shared list, so they can never get out of sync.
- `NavigationService` (navigator key) and `AppMessage` (ScaffoldMessenger key) let providers navigate and show SnackBars without a `BuildContext`.

Why this approach: Provider is simple and officially recommended, and the BaseView/BaseProvider pattern keeps one clear provider per page with a shared store. It is the pattern our team already uses. BLoC would add events and states for every action without a real benefit at this size.

---

## 6. How it works (main flows)

| Flow | Path through the code |
|------|------------------------|
| App start | `main` → `setUpLocator` → `HomePage` → `HomeProvider.init()` → `VisitorStore.loadVisitors()` → `GET /visitors` |
| Register | `VisitorFormPage` → `VisitorFormProvider.save()` → validate → `POST /visitors` → `store.save` → `RegisteredDialog` (QR) → replace with details page |
| Edit | `navigateTo(visitorFormPage, visitor)` → `configure` → `PUT /visitors/{id}` (form fields only) → `store.save` → back |
| Delete | `BaseProvider.deleteVisitor` → `AppConfirmDialog` → `DELETE /visitors/{id}` → `store.remove` |
| Search / filter | `VisitorListProvider.filteredVisitors` (local, by name or mobile + status chip) |
| Check-in / out | `VisitorDetailsProvider.changeStatus` → `isUpdating` guard → `GET` latest status → rule check → `PUT {status, time}` → `store.save` → all pages update |
| QR scan | `QrScannerProvider.onDetect` → `isProcessing` guard → `QrHelper.readVisitorId` → `GET /visitors/{id}` → stop camera → details page → restart camera on return |

---
