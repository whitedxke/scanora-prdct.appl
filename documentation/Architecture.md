# Architecture.

## 1. Layers.

- **UI**: screens, reusable components, navigation.
- **Controllers (state and business orchestration)**: screen state management and flow coordination.
- **Repositories**: event storage contracts and implementations.
- **Utils**: QR resolving, payload encoding, resource resolving, infrastructure abstractions.
- **Models**: domain models (`Event`, `EventStatus`, mock templates, etc).

## 2. Key Principles.

- **DIP**: controllers depend on abstractions (`EventRepository`, `CameraPermissionService`, `QRCodeResolving`), not concrete types.
- **SRP**: infrastructure and utility responsibilities are extracted into dedicated components.
- **Low coupling**: UI does not depend on storage internals — screens and controllers only see repository / service protocols.

## 3. Composition Root.

`ScanoraApp` (`App/ScanoraApp.swift`) owns a single `PersistentEventRepository` instance as a `@StateObject` and passes it into `AppNavigation` (`Navigation/Navigation.swift`).

`AppNavigation` builds one `NavigationStack` rooted at the scanner screen, with an overlay button pushing to the events list. Each screen has its own private `*Scene` wrapper that constructs a controller (`ScannerController`, `EventsListController`) from the shared repository instance — so every screen observes the same data through Combine.

## 4. Domain Models.

- `Event` (`Models/Event/Event.swift`) — `Identifiable`, `Codable`, `Hashable`. Fields: `id`, `title`, `eventDescription`, `date`, `image`. `status` is a computed property (`date > .now` → `.upcoming`, otherwise `.completed`) and is excluded from encoding via explicit `CodingKeys`.
- `EventStatus` (`Models/Event/EventStatus.swift`) — `upcoming` / `completed`, with localized display titles.
- `MockEventPool` (`Models/MockEventPool/MockEventPool.swift`) — a static pool of ~7 sample event templates, used as a deterministic fallback source when a scanned QR payload isn't valid event JSON. See [Scanner.md](Scanner.md).

## 5. UI Layer.

- Screens: `ScannerScreen`, `EventsListScreen`, `EventDetailsScreen` — each paired 1:1 with an `ObservableObject` controller that owns `@Published` state.
- Reusable components: `CircleButton` / `CircleIcon` (chrome), `EventImageView` (renders a remote URL, a local asset, or a placeholder), `EventQRCodeView` (QR image generation, see [Scanner.md](Scanner.md)).
- `EventImageResourceResolver` decides whether an event's `image` string is a remote `http(s)` URL, the legacy `"event_mock_banner"` string (mapped to the bundled `MockEventBanner` asset), another asset name, or empty (placeholder).

## 6. Backend Readiness.

Current setup uses `PersistentEventRepository` + `JSONFileEventStore` (see [Persistence.md](Persistence.md) and [Repository.md](Repository.md)).

To switch to a backend, add a new repository implementation (for example, `RemoteEventRepository`) and wire it in `ScanoraApp` in place of `PersistentEventRepository`. UI and controllers depend only on the `EventRepository` protocol, so they remain unchanged.

## 7. Full Project Structure.

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
    │   └── MockEventBanner.imageset/
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

### 7.1. Root and Xcode Configuration.

- `Scanora/Scanora.xcodeproj/project.pbxproj` — main Xcode project configuration (targets, build settings, phases, signing, etc).
- `Scanora/Scanora.xcodeproj/project.xcworkspace/contents.xcworkspacedata` — workspace descriptor.
- `Scanora/Scanora.xcodeproj/project.xcworkspace/xcuserdata/.../UserInterfaceState.xcuserstate` — local IDE UI state artifact.
- `Scanora/Scanora.xcodeproj/xcuserdata/.../xcschemes/xcschememanagement.plist` — local Xcode scheme management settings.

### 7.2. Application Source Folder `Scanora/Scanora`.

#### `App`.

- `App/ScanoraApp.swift` — application entry point, top-level dependency composition, root navigation bootstrap.

#### `Assets.xcassets`.

- `Assets.xcassets/Contents.json` — root asset catalog manifest.
- `Assets.xcassets/AccentColor.colorset/Contents.json` — accent color configuration.
- `Assets.xcassets/AppIcon.appiconset/Contents.json` — application icon configuration.
- `Assets.xcassets/MockEventBanner.imageset/Contents.json` — image set manifest.
- `Assets.xcassets/MockEventBanner.imageset/event_mock_banner.png` — banner image 1x.
- `Assets.xcassets/MockEventBanner.imageset/event_mock_banner@2x.png` — banner image 2x.
- `Assets.xcassets/MockEventBanner.imageset/event_mock_banner@3x.png` — banner image 3x.

#### `Models`.

- `Models/Event/Event.swift` — main event domain model (`id`, `title`, `eventDescription`, `date`, `image`), `Codable` and `Hashable`.
- `Models/Event/EventStatus.swift` — status model (`upcoming`, `completed`) and display labels.
- `Models/MockEventPool/MockEventPool.swift` — mock event templates used by hash-based fallback generation.

#### `Navigation`.

- `Navigation/Navigation.swift` — root application navigation, wires the scanner and event list flows.

#### `Repositories`.

- `Repositories/EventRepository.swift` — event storage contract (`eventsSnapshot`, `eventsPublisher`, `add`, `containsEvent`).
- `Repositories/MemoryEventRepository.swift` — in-memory repository implementation.
- `Repositories/EventPersistence.swift` — infrastructure abstractions and implementations (`EventStore`, `JSONFileEventStore`, `Logger`).
- `Repositories/PersistentEventRepository.swift` — repository implementation with persistence through `EventStore`.

#### `UI`.

- `UI/Components/Buttons/CircleButton.swift` — reusable circular action button.
- `UI/Components/Icons/CircleIcon.swift` — reusable circular visual icon container.
- `UI/Components/EventImageView.swift` — event image renderer (remote URL, local asset and placeholder).
- `UI/Components/EventQRCodeView.swift` — QR-image generation and rendering in modal presentation.
- `UI/EventDetailsScreen/EventDetailsController.swift` — details screen controller and state holder.
- `UI/EventDetailsScreen/EventDetailsScreen.swift` — event details screen.
- `UI/EventsListScreen/EventsListController.swift` — list screen controller (mode switching, filtering, view states).
- `UI/EventsListScreen/EventsListScreen.swift` — event list screen.
- `UI/ScannerScreen/ScannerController.swift` — scanner controller (permissions, throttling, scan result handling).
- `UI/ScannerScreen/ScannerDependencies.swift` — scanner dependency abstractions and default system adapters (`CameraPermissionService`, `QRCodeResolving`).
- `UI/ScannerScreen/ScannerScreen.swift` — scanner screen UI.
- `UI/ScannerScreen/Camera/QRScannerView.swift` — SwiftUI wrapper around the UIKit scanner controller.
- `UI/ScannerScreen/Camera/QRScannerViewController.swift` — UIKit camera scanner built on `AVCaptureSession`.

#### `Utils`.

- `Utils/DateUtils.swift` — date formatting helpers for UI display.
- `Utils/QRCodeResolver.swift` — parsing and resolving a raw QR payload into a domain event model.
- `Utils/EventImageResourceResolver.swift` — image source resolution (URL vs asset).
- `Utils/EventQRCodePayloadEncoder.swift` — encoding an `Event` into a QR payload string.
- `Utils/Extensions/IntExtension.swift` — `Optional<Int>` utility extension.
- `Utils/Extensions/StringExtension.swift` — `Optional<String>` utility extension.
- `Utils/State/CameraPermissionState.swift` — camera permission state model.
- `Utils/State/ViewState.swift` — generic presentation state (`idle` / `loading` / `empty` / `success` / `error`).
