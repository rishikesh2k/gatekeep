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

## 4. Mock API setup (MockAPI.io)

1. Sign in at <https://mockapi.io> and create a new project.
2. Add a resource named **`visitors`** with these fields (all type *String*, nothing auto-generated except `id`):

   `name, mobile, email, visitor_type, project, purpose, status, created_at, check_in_time, check_out_time`

3. Set the number of generated records to **0** so the list starts empty (or add sample data from section 5).
4. Copy the project endpoint, for example `https://6720abcd1234.mockapi.io/api/v1`.

### Endpoints used

| Method | Endpoint | Used for |
|--------|----------|----------|
| GET | `/visitors` | Load all visitors (list + dashboard) |
| GET | `/visitors/{id}` | Details after QR scan, latest status before check-in/out |
| POST | `/visitors` | Register a visitor |
| PUT | `/visitors/{id}` | Edit details, and check-in / check-out (only changed fields are sent) |
| DELETE | `/visitors/{id}` | Delete a visitor |

> MockAPI.io supports `PUT` for updates and merges the fields sent, so `PUT` is used for both edit and status changes. The QR code and lookups always use the server-generated `id`.

---

### When the mock API is not connected

If `API_BASE_URL` is not set, or the API can't be reached (no internet, timeout), every request is answered from `LocalDataService` instead. It keeps visitors in **shared preferences**. On first use it is seeded with four dummy visitors (`utils/dummy_visitors.dart`). Register, edit, delete and check-in/out all work and survive an app restart. The dashboard and list show a banner: *"Mock API not connected. Showing data saved on this phone."*

---

## 5. Sample record

```json
{
  "name": "Rahul Sharma",
  "mobile": "9876543210",
  "email": "rahul@example.com",
  "visitor_type": "Customer",
  "project": "Project A",
  "purpose": "Site Visit",
  "status": "Registered",
  "created_at": "2026-10-26T10:00:00+05:30",
  "check_in_time": null,
  "check_out_time": null
}
```

Check-in body: `{"status": "Checked In", "check_in_time": "2026-10-26T10:30:00+05:30"}`
Check-out body: `{"status": "Checked Out", "check_out_time": "2026-10-26T11:30:00+05:30"}`

---

## 6. Run the project

```bash
flutter pub get

# Option 1: pass the API URL at run time (recommended)
flutter run --dart-define=API_BASE_URL=https://<your-id>.mockapi.io/api/v1

# Option 2: edit the default value in lib/utils/api_constants.dart
flutter run
```

Build the APK:

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://<your-id>.mockapi.io/api/v1
# output: build/app/outputs/flutter-apk/app-release.apk
```

Run tests:

```bash
flutter test
```

---

## 7. Project structure

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

## 8. State management: Provider + BaseView / BaseSelector

- **`locator.dart` (GetIt)**: `ApiService` and `VisitorStore` are lazy singletons (one for the whole app). Each page provider is a factory, so every page gets a new one.
- **`BaseView<T>`** creates the page provider from the locator, calls `onModelReady` to pass the page arguments, provides it with `ChangeNotifierProvider.value`, and disposes it when the page closes.
- **`BaseSelector<T, V>`** wraps `Selector`, so only the part whose selected value changed is rebuilt (for example only the Save button when `busy` changes).
- **`BaseProvider`** gives every provider `api`, `store`, `busy` / `runBusy` and a safe `customNotify`. It also **listens to `VisitorStore`**, so when any page changes a visitor (register, edit, delete, check-in, check-out), the dashboard, list and details all rebuild with the new data, with no restart and no extra reload.
- Dashboard counts are getters on the shared list, so they can never get out of sync.
- `NavigationService` (navigator key) and `AppMessage` (ScaffoldMessenger key) let providers navigate and show SnackBars without a `BuildContext`.

Why this approach: Provider is simple and officially recommended, and the BaseView/BaseProvider pattern keeps one clear provider per page with a shared store. It is the pattern our team already uses. BLoC would add events and states for every action without a real benefit at this size.

---

## 9. How it works (main flows)

| Flow | Path through the code |
|------|------------------------|
| App start | `main` → `setUpLocator` → `HomePage` → `HomeProvider.init()` → `VisitorStore.loadVisitors()` → `GET /visitors` |
| Register | `VisitorFormPage` → `VisitorFormProvider.save()` → validate → `POST /visitors` → `store.save` → `RegisteredDialog` (QR) → replace with details page |
| Edit | `navigateTo(visitorFormPage, visitor)` → `configure` → `PUT /visitors/{id}` (form fields only) → `store.save` → back |
| Delete | `BaseProvider.deleteVisitor` → `AppConfirmDialog` → `DELETE /visitors/{id}` → `store.remove` |
| Search / filter | `VisitorListProvider.filteredVisitors` (local, by name or mobile + status chip) |
| Check-in / out | `VisitorDetailsProvider.changeStatus` → `isUpdating` guard → `GET` latest status → rule check → `PUT {status, time}` → `store.save` → all pages update |
| QR scan | `QrScannerProvider.onDetect` → `isProcessing` guard → `QrHelper.readVisitorId` → `GET /visitors/{id}` → stop camera → details page → restart camera on return |

The full step-by-step flow is in [PROJECT_GUIDE.md](PROJECT_GUIDE.md).

---

## 10. Business rules and duplicate prevention

- Check-in only from **Registered**; check-out only from **Checked In**; **Checked Out** shows a disabled "Visit Completed" button.
- Before each status change the app first does a `GET /visitors/{id}` to read the latest status from the server. So even if another device already checked the visitor in, a second check-in is blocked.
- `isUpdating` in `VisitorDetailsProvider` blocks a second request while one is running, and the button shows a spinner.
- `QrScannerProvider` uses an `isProcessing` flag. The camera fires `onDetect` many times a second, and only the first one is handled until the user returns from details or the error message finishes.

---

## 11. Error handling

| Case | What the user sees |
|------|-------------------|
| No internet / timeout / server error | Clear message in a SnackBar, or an error screen with **Try Again** |
| Bad JSON from server | "Invalid data received from server" |
| Empty list | Empty state with an icon and a Refresh button |
| Search with no result | "No matching visitors" |
| Invalid QR | "Invalid QR code. This is not a visitor pass." |
| Unknown visitor ID | "No visitor found for this QR code." |
| Camera permission denied | Message telling the user to allow camera access in settings |
| Wrong status action | e.g. "Visitor is already checked in" |

---

## 12. Interview questions (short answers)

| Question | Answer |
|----------|--------|
| Explain the architecture | Page → page provider → ApiService → MockAPI, with a shared `VisitorStore`. Pages only build UI, providers hold the state and logic, and `ApiService` is the only class that does HTTP. |
| Why `locator.dart` / GetIt? | One place to register everything. Services are lazy singletons and page providers are factories. Tests register a fake `ApiService`. |
| What do BaseView / BaseSelector do? | BaseView creates, provides and disposes the page provider. BaseSelector rebuilds only the part whose selected value changed. |
| How does a check-in update the list and dashboard? | `store.save(updated)` → the store notifies → every page provider (listening via `BaseProvider`) calls `customNotify` → the selectors rebuild. |
| How is a duplicate check-in prevented? | `isUpdating` guard, a fresh `GET` of the server status before the `PUT`, and the button changes with the status. |
| How are repeated scanner callbacks prevented? | `isProcessing` flag, plus stopping the camera while details is open. |
| Invalid QR vs unknown visitor? | Bad format → "Invalid QR code". Valid format but 404 → "No visitor found". |
| How are API errors handled? | `DioClient.handleDioException` maps timeout, connection, non-2xx and bad response errors to `ApiException`. Providers show it in a SnackBar or an error view with retry. |
| Why PUT not PATCH? | MockAPI merges the fields sent with PUT, so it works like PATCH. |
| What happens when the mock API is down? | Network errors fall back to `LocalDataService`, which keeps visitors in shared preferences (seeded with dummy data). A banner tells the user. |
| What would you improve? | Syncing local changes back to the API, visit history, a server-side status check, pagination and server search, login. |

All questions with detailed answers (40+) are in [PROJECT_GUIDE.md](PROJECT_GUIDE.md#part-c--interview-questions--answers).

---

## 13. Screenshots

Put screenshots in the `screenshots/` folder:

| Dashboard | Visitor List | Registration | Details & QR | Scanner |
|-----------|--------------|--------------|--------------|---------|
| `screenshots/dashboard.png` | `screenshots/visitor_list.png` | `screenshots/register.png` | `screenshots/details.png` | `screenshots/scanner.png` |

---

## 14. Known limitations

- One visit per registration. A repeat visitor is registered again (as allowed by the assignment).
- Search and filter run locally on the loaded list.
- Free MockAPI projects have a record limit and no authentication.
- Local data and API data are separate. Visitors created while the API is down stay on the phone and are not synced to MockAPI later.
- "Today" uses the phone's local date, so a phone with the wrong date shows wrong counts.
