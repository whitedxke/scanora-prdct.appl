# Scanora.

Scanora is an iOS application for scanning event QR-codes: a user scans a code, event data is extracted from the payload and saved locally, saved events are browsable in a list and a details screen, and each event's QR-code can be re-rendered from its details screen. The project is a learning and practice implementation focused on clear layered architecture and readiness for future backend integration.

## Features.

- Scan an event QR-code with the device camera.
- Parse event data from a QR payload, with a deterministic mock fallback for unrecognized payloads.
- Save scanned events locally, with duplicate detection.
- Browse events in a list, filterable by upcoming / completed.
- View full event details.
- Re-render an event as a QR-code from its details screen.

## Architecture.

- Layered: UI → Controllers → Repositories → Models, with Utils for infrastructure and helpers.
- Dependency Inversion: controllers and screens depend on protocols (`EventRepository`, `CameraPermissionService`, `QRCodeResolving`), not concrete types.
- No backend yet — storage goes through an `EventStore` abstraction, so a backend can be added without touching UI or business logic.

Full breakdown: [documentation/Architecture.md](documentation/Architecture.md).

## Tech Stack.

Apple system frameworks only, no third-party dependencies:

- `SwiftUI` — screens, navigation, reusable components.
- `Combine` — state publishing and observation in controllers and repositories.
- `Foundation` — core platform utilities, JSON coding, file I/O.
- `AVFoundation` — camera capture and QR scanning.
- `CoreImage` — QR-code image generation.
- `UIKit` — camera scanner view controller, bridged into SwiftUI.
- `CryptoKit` — SHA256 hashing for the QR fallback resolution path.

## Project Structure.

```text
Scanora/
├── Scanora.xcodeproj/
└── Scanora/
    ├── App/               # Entry point and composition root.
    ├── Assets.xcassets/
    ├── Models/            # Event, EventStatus, MockEventPool.
    ├── Navigation/
    ├── Repositories/      # EventRepository, EventStore and implementations.
    ├── UI/                # Screens and reusable components, grouped by feature.
    └── Utils/             # QR resolving/encoding, resource resolving, state helpers.
```

Full file-by-file listing: [documentation/Architecture.md](documentation/Architecture.md).

## Roadmap.

- Backend / API integration behind a `RemoteEventRepository`.
- Cross-device sync and cloud backup.
- Broader automated test coverage (unit and integration).
- Centralized crash/error reporting; retry and backoff once real network calls exist.
- Localization beyond current in-app strings.
- Encrypted local storage and broader security hardening.

## How to Run.

Requires macOS, Xcode (latest stable recommended) and Git.

```bash
git clone https://github.com/whitedxke/scanora-prdct.appl.git
cd scanora-prdct.appl
open Scanora/Scanora.xcodeproj
```

There are no dependencies to fetch (`pod install` / `swift package resolve` are not needed). In Xcode, select the `Scanora` scheme and press `Cmd + R` to run on a simulator, or connect a device and configure signing for the `Scanora` target.

To build from the CLI instead:

```bash
xcodebuild -project Scanora/Scanora.xcodeproj -scheme Scanora -configuration Debug -destination "generic/platform=iOS" build
```

---

Detailed documentation is available under [/documentation](documentation).
