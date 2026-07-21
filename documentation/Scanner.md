# Scanner.

Covers the full QR-code lifecycle: camera capture, payload resolution, and generating a QR-code back from a stored event.

## 1. Capture Flow.

`ScannerScreen` requests camera permission on `onAppear`. `ScannerController.cameraPermission` (`CameraPermissionState`: `.notDetermined` / `.authorized` / `.denied`) drives which UI is shown — permission prompt, denied message, or the live camera feed.

`QRScannerView` (`UIViewControllerRepresentable`) wraps `QRScannerViewController` (UIKit, `AVCaptureSession`) and starts/stops the capture session based on the `isScanning` flag it's given.

When a QR-code is detected, a background `AVCaptureMetadataOutputObjectsDelegate` (`MetadataDelegate`) calls a handler that hops to `@MainActor` and invokes the SwiftUI `Coordinator`, which calls `controller.handleScannedData(rawValue)`.

## 2. Throttling and State Machine.

`ScannerController`:

- Ignores new scans within 2 seconds of the last one (`lastScannedDate`), and only processes a scan while `state == .idle`.
- Simulates a 300ms processing delay (`Task.sleep`) before resolving — there's no real backend call yet, this exists to make the loading state visible.
- Drives UI through `ViewState<String>`: `idle` / `loading` / `success(message)` / `error(message)`, rendered as a border, spinner, green checkmark card, or red error card respectively.

## 3. Camera Permission.

`CameraPermissionService` protocol, implemented by `SystemCameraPermissionService` (wraps `AVCaptureDevice.authorizationStatus` / `requestAccess`). Access is only requested when the current status is `.notDetermined` — an already-denied or already-authorized status is read, not re-prompted.

## 4. QR Payload Resolution.

`QRCodeResolver.resolve(rawValue:existingIDs:)` (`Utils/QRCodeResolver.swift`) is two-stage:

1. **JSON parsing.** Attempts to decode the raw string as an `EventQRCodePayload` (`id`, `title`, `description`, `date`, `status`, `image` — all optional). Requires `id`, a non-empty `title`, and `date` to build an `Event`; `date` is parsed via `ISO8601DateFormatter` (falls back to `.now` on failure), `image` defaults to `"MockEventBanner"` if absent.
2. **Hash fallback.** Any string that fails JSON parsing is still turned into an `Event`, deterministically: a SHA256 hash (`CryptoKit`) of the raw string is computed, its first 8 bytes become a `UInt64` seed used both to pick a template from `MockEventPool` (`seed % templateCount`) and to derive the event's `id` (masked to a positive `Int`). The same input string always maps to the same generated event.

In both cases, the resolved event's `id` is checked against `existingIDs` (the repository's current snapshot); a match returns `.duplicate` instead of `.success`.

## 5. QR Code Generation (Reverse Direction).

`JSONEventQRCodePayloadEncoder` (`Utils/EventQRCodePayloadEncoder.swift`) serializes an `Event` back into a JSON string (`id`, `title`, `description`, `date`, `image`, sorted keys) — the same shape `QRCodeResolver` expects, so a QR-code rendered by the app can be re-scanned by another instance of it.

`EventQRCodeView` renders that payload as an image via `CoreImage`'s `CIFilter.qrCodeGenerator`, scaled 10x for crispness, and is presented as a sheet from `EventDetailsScreen`.

## 6. Related: Banner Image Resolution.

Not scanner-specific, but reached from the same `image` field: `EventImageResourceResolver` (`Utils/EventImageResourceResolver.swift`) decides whether an event's `image` string is a remote `http(s)` URL, the legacy `"event_mock_banner"` string (mapped to the bundled `MockEventBanner` asset), another asset name, or empty (→ placeholder). Used by `EventImageView` on both the list and details screens.
