# Scanora.

Scanora is an iOS application for scanning event QR-codes, storing events locally and browsing them in a structured list.

## 1. Project Purpose.

The application implements a clear end-user flow:

1. A user scans a QR-code.
2. Event data is extracted from the QR payload.
3. The event is saved locally.
4. Events are shown in a list and available in a details screen.
5. A QR-code can be rendered for each event.

This project is built as a learning and practice implementation with focus on:

- Understandable architecture.
- Clear separation of responsibilities.
- Readiness for future backend integration.

## 2. Current Status and Context.

At this stage there is no backend service, so data is stored locally (JSON-file in the application Documents directory).

This is an intentional decision for the current phase. The repository layer already isolates data source details.  
When a backend appears, changes should be mostly limited to the `Repository` layer without rewriting UI or core business flow.

## 3. Architecture and Implementation.

### 3.1. Main Layers.

- **UI (SwiftUI)**: screens, reusable components, navigation.
- **Controllers (state and business orchestration)**: screen state management and flow coordination.
- **Repositories**: event storage contracts and implementations.
- **Utils**: QR resolving, payload encoding, resource resolving, infrastructure abstractions.
- **Models**: domain models (`Event`, `EventStatus`, mock templates, etc).

### 3.2. Key Principles.

- **DIP**: controllers depend on abstractions (`EventRepository`, `CameraPermissionService`, `QRCodeResolving`).
- **SRP**: infrastructure and utility responsibilities are extracted into dedicated components.
- **Low coupling**: UI does not depend on storage internals.

### 3.3. Backend Readiness.

Current setup uses `PersistentEventRepository` + `JSONFileEventStore`.  
To switch to a backend, add a new repository implementation (for example, `RemoteEventRepository`) and wire it in the application composition root.  
UI and most domain and business logic can remain unchanged.

## 4. Project Structure.

Below is the current project structure with a description of **every folder and file**.

```text
Scanora/
├── Scanora.xcodeproj/
│   ├── project.pbxproj
│   ├── project.xcworkspace/contents.xcworkspacedata
│   ├── project.xcworkspace/xcuserdata/.../UserInterfaceState.xcuserstate
│   └── xcuserdata/.../xcschemes/xcschememanagement.plist
└── Scanora/
    ├── App/
    │   └── ScanoraApp.swift
    ├── Assets.xcassets/
    │   ├── Contents.json
    │   ├── AccentColor.colorset/Contents.json
    │   ├── AppIcon.appiconset/Contents.json
    │   └── MockAnthropicEventBanner.imageset/
    │       ├── Contents.json
    │       ├── event_mock_banner.png
    │       ├── event_mock_banner@2x.png
    │       └── event_mock_banner@3x.png
    ├── Models/
    │   ├── Event/
    │   │   ├── Event.swift
    │   │   └── EventStatus.swift
    │   └── MockEventPool/
    │       └── MockEventPool.swift
    ├── Navigation/
    │   └── Navigation.swift
    ├── Repositories/
    │   ├── EventPersistence.swift
    │   ├── EventRepository.swift
    │   ├── MemoryEventRepository.swift
    │   └── PersistentEventRepository.swift
    ├── UI/
    │   ├── Components/
    │   │   ├── Buttons/CircleButton.swift
    │   │   ├── Icons/CircleIcon.swift
    │   │   ├── EventImageView.swift
    │   │   └── EventQRCodeView.swift
    │   ├── EventDetailsScreen/
    │   │   ├── EventDetailsController.swift
    │   │   └── EventDetailsScreen.swift
    │   ├── EventsListScreen/
    │   │   ├── EventsListController.swift
    │   │   └── EventsListScreen.swift
    │   └── ScannerScreen/
    │       ├── ScannerController.swift
    │       ├── ScannerDependencies.swift
    │       ├── ScannerScreen.swift
    │       └── Camera/
    │           ├── QRScannerView.swift
    │           └── QRScannerViewController.swift
    └── Utils/
        ├── DateUtils.swift
        ├── EventImageResourceResolver.swift
        ├── EventQRCodePayloadEncoder.swift
        ├── QRCodeResolver.swift
        ├── Extensions/
        │   ├── IntExtension.swift
        │   └── StringExtension.swift
        └── State/
            ├── CameraPermissionState.swift
            └── ViewState.swift
```

### 4.1. Root and Xcode Configuration.

- `Scanora/Scanora.xcodeproj/project.pbxproj` — main Xcode project configuration (targets, build settings, phases, signing, etc).
- `Scanora/Scanora.xcodeproj/project.xcworkspace/contents.xcworkspacedata` — workspace descriptor.
- `Scanora/Scanora.xcodeproj/project.xcworkspace/xcuserdata/.../UserInterfaceState.xcuserstate` — local IDE UI state artifact.
- `Scanora/Scanora.xcodeproj/xcuserdata/.../xcschemes/xcschememanagement.plist` — local Xcode scheme management settings.

### 4.2. Application Source Folder `Scanora/Scanora`.

#### `Application`.

- `Scanora/Scanora/App/ScanoraApp.swift` — application entry point, top-level dependency composition, root navigation bootstrap.

#### `Assets.xcassets`.

- `Scanora/Scanora/Assets.xcassets/Contents.json` — root asset catalog manifest.
- `Scanora/Scanora/Assets.xcassets/AccentColor.colorset/Contents.json` — accent color configuration.
- `Scanora/Scanora/Assets.xcassets/AppIcon.appiconset/Contents.json` — application icon configuration.
- `Scanora/Scanora/Assets.xcassets/MockAnthropicEventBanner.imageset/Contents.json` — image set manifest.
- `Scanora/Scanora/Assets.xcassets/MockAnthropicEventBanner.imageset/event_mock_banner.png` — banner image 1x.
- `Scanora/Scanora/Assets.xcassets/MockAnthropicEventBanner.imageset/event_mock_banner@2x.png` — banner image 2x.
- `Scanora/Scanora/Assets.xcassets/MockAnthropicEventBanner.imageset/event_mock_banner@3x.png` — banner image 3x.

#### `Models`.

- `Scanora/Scanora/Models/Event/Event.swift` — main event domain model (`id`, `title`, `eventDescription`, `date`, `image`), `Codable` and `Hashable`.
- `Scanora/Scanora/Models/Event/EventStatus.swift` — status model (`upcoming`, `completed`) and display labels.
- `Scanora/Scanora/Models/MockEventPool/MockEventPool.swift` — mock event templates used by hash-based fallback generation.

#### `Navigation`.

- `Scanora/Scanora/Navigation/Navigation.swift` — root application navigation, that wires scanner and event list flows.

#### `Repositories`.

- `Scanora/Scanora/Repositories/EventRepository.swift` — event storage contract (`snapshot`, `publisher`, `add`, `contains`).
- `Scanora/Scanora/Repositories/MemoryEventRepository.swift` — in-memory repository implementation.
- `Scanora/Scanora/Repositories/EventPersistence.swift` — infrastructure abstractions and implementations (`EventStore`, `JSONFileEventStore`, `Logger`).
- `Scanora/Scanora/Repositories/PersistentEventRepository.swift` — repository implementation with persistence through `EventStore`.

#### `UI`.

- `Scanora/Scanora/UI/Components/Buttons/CircleButton.swift` — reusable circular action button.
- `Scanora/Scanora/UI/Components/Icons/CircleIcon.swift` — reusable circular visual icon container.
- `Scanora/Scanora/UI/Components/EventImageView.swift` — event image renderer (remote URL, local asset and placeholder).
- `Scanora/Scanora/UI/Components/EventQRCodeView.swift` — QR-image generation and rendering in modal presentation.
- `Scanora/Scanora/UI/EventDetailsScreen/EventDetailsController.swift` — details screen controller and state holder.
- `Scanora/Scanora/UI/EventDetailsScreen/EventDetailsScreen.swift` — event details screen.
- `Scanora/Scanora/UI/EventsListScreen/EventsListController.swift` — list screen controller (mode switching, filtering, + (loading, empty and success) states).
- `Scanora/Scanora/UI/EventsListScreen/EventsListScreen.swift` — event list screen.
- `Scanora/Scanora/UI/ScannerScreen/ScannerController.swift` — scanner controller (permissions, throttling, scan result handling).
- `Scanora/Scanora/UI/ScannerScreen/ScannerDependencies.swift` — scanner dependency abstractions and default system adapters (`CameraPermissionService`, `QRCodeResolving`).
- `Scanora/Scanora/UI/ScannerScreen/ScannerScreen.swift` — scanner screen UI.
- `Scanora/Scanora/UI/ScannerScreen/Camera/QRScannerView.swift` — SwiftUI wrapper around UIKit scanner controller.
- `Scanora/Scanora/UI/ScannerScreen/Camera/QRScannerViewController.swift` — UIKit camera scanner built on `AVCaptureSession`.

#### `Utils`.

- `Scanora/Scanora/Utils/DateUtils.swift` — date formatting helpers for UI display.
- `Scanora/Scanora/Utils/QRCodeResolver.swift` — parsing and resolving raw QR payload into domain event model.
- `Scanora/Scanora/Utils/EventImageResourceResolver.swift` — image source resolution (URL vs asset).
- `Scanora/Scanora/Utils/EventQRCodePayloadEncoder.swift` — encoding `Event` into QR payload string.
- `Scanora/Scanora/Utils/Extensions/IntExtension.swift` — `Optional<Int>` utility extension.
- `Scanora/Scanora/Utils/Extensions/StringExtension.swift` — `Optional<String>` utility extension.
- `Scanora/Scanora/Utils/State/CameraPermissionState.swift` — camera permission state model.
- `Scanora/Scanora/Utils/State/ViewState.swift` — generic presentation state (`idle/loading/empty/success/error`).

## 5. Environment Requirements.

Install:

- macOS;
- Xcode (latest stable recommended);
- iOS SDK (bundled with Xcode);
- Git.

Quick check:

```bash
xcodebuild -version.
git --version.
```

## 6. Clone From GitHub.

```bash
git clone https://github.com/whitedxke/scanora-prdct.appl.git.
cd scanora-prdct.appl.
```

Open in Xcode:

```bash
open Scanora/Scanora.xcodeproj.
```

## 7. Dependencies.

### 7.1. Current Dependencies.

There are currently **no third-party libraries**.

The project uses Apple system frameworks only.  
Below is what each dependency is used for in this codebase:

- `SwiftUI`.  
  Primary UI framework for screens, navigation and reusable components (`ScannerScreen`, `EventsListScreen`, `EventDetailsScreen` and UI components under `UI and Components`).

- `Combine`.  
  State publishing and observation (`Published`, `AnyPublisher`) in controllers and repositories.  
  Used to reactively update UI, when event data changes.

- `Foundation`.  
  Core platform utilities: `Date`, `URL`, `Data`, JSON encoding and decoding, file operations and base types used across almost all layers.

- `AVFoundation`.  
  Camera and QR scanning pipeline (`AVCaptureSession`, metadata output, permission access) in scanner-related modules.

- `CoreImage`.  
  QR-image generation and rendering in `EventQRCodeView` via `CIFilter.qrCodeGenerator`.

- `UIKit`.  
  Camera scanner controller implementation (`UIViewController`) and bridge layer required by `UIViewControllerRepresentable` in SwiftUI.

### 7.2. How to Fetch Dependencies.

At the current stage there is nothing extra to fetch:

- `pod install` is not required;
- `swift package resolve` is not required (no external SPM packages configured).

### 7.3. How to Add Dependencies Later.

Via Xcode:

1. `File` → `Add Package Dependencies...`.
2. Paste package URL.
3. Select version.
4. Attach package product to target `Scanora`.

Xcode will resolve and integrate dependencies automatically.

## 8. Build Instructions.

### 8.1. Build in Xcode.

1. Open `Scanora.xcodeproj`.
2. Select scheme `Scanora`.
3. Choose configuration (`Debug` or `Release`).
4. `Product` → `Build`.

### 8.2. Build via CLI (`xcodebuild`).

#### Debug.

```bash
xcodebuild \
  - project Scanora/Scanora.xcodeproj \
  - scheme Scanora \
  - configuration Debug \
  - destination "generic/platform=iOS" \
  build
```

#### Release.

```bash
xcodebuild \
  - project Scanora/Scanora.xcodeproj \
  - scheme Scanora \
  - configuration Release \
  - destination "generic/platform=iOS" \
  build
```

Unsigned local build (useful for CI/local checks):

```bash
xcodebuild \
  - project Scanora/Scanora.xcodeproj \
  - scheme Scanora \
  - configuration Debug \
  - destination "generic/platform=iOS" \
  CODE_SIGNING_ALLOWED=NO \
  CODE_SIGNING_REQUIRED=NO \
  build
```

## 9. Run Instructions.

Run on simulator:

1. Select an iOS Simulator target.
2. Press `Run` (`Cmd + R`).

Run on physical device:

1. Connect device.
2. Configure signing for target `Scanora`.
3. Press `Run`.

## 10. Current Limitations.

Current limitations are grouped below so it is clear what is intentionally simplified at this stage and what should be improved next.

### 10.1. Data Source and Networking.

- There is no backend and API integration yet.
- Event data is stored locally only (`JSONFileEventStore` in application Documents).
- The application has no authentication, authorization or user accounts.
- There is no remote schema and version negotiation for payload compatibility.

### 10.2. Synchronization and Multi-Device Behavior.

- No cross-device sync (data exists only on the current device).
- No cloud backup and restore strategy implemented at application level.
- No conflict resolution logic (not needed yet because there is no shared remote source).

### 10.3. Reliability and Error Handling.

- Error handling is intentionally lightweight for this phase.
- Infrastructure logging currently uses a simple logger abstraction with console output by default.
- No centralized crash and error reporting service is connected.
- No retry and backoff policies are implemented (there are no network operations yet).

### 10.4. Testing and Quality Gates.

- Automated test coverage is limited.
- No full unit and integration test suite for repositories, scanner flow and view state transitions.
- No CI quality gate is documented in this repository yet (lint, test and build pipeline policy is not formalized in README).

### 10.5. Product and UX Scope.

- The application implements a focused MVP scenario only: scan -> store -> list -> details.
- No advanced search, filter or sort features beyond the current mode toggle.
- No localization strategy beyond current in-application strings.
- No offline-first migration strategy is needed yet because storage is currently local-first by design.

### 10.6. Security and Privacy Scope.

- Camera permission flow is implemented, but broader privacy and security hardening is intentionally minimal at this stage.
- There is no encrypted local storage layer for events yet.
- There is no backend transport security policy in code because there is no remote API integration yet.

----

## Note.

This project is a practical learning implementation focused on iOS architecture and engineering fundamentals in Swift.  
Experience in this area is still growing, so the current solution prioritizes clarity, maintainability and backend-readiness with minimal future rewrites.
