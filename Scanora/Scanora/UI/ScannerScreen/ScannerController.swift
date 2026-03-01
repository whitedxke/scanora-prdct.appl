//
//  ScannerController.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Combine
import Foundation

@MainActor
final class ScannerController: ObservableObject {
    @Published private(set) var state: ViewState<String> = .idle
    @Published private(set) var cameraPermission: CameraPermissionState = .notDetermined

    var isScanning: Bool {
        if case .idle = state {
            return cameraPermission == .authorized
        }

        return false
    }

    private let eventRepository: EventRepository
    private let cameraPermissionService: CameraPermissionService
    private let qrCodeResolver: QRCodeResolving
    private var lastScannedDate: Date = .distantPast

    init(
        eventRepository: EventRepository,
        cameraPermissionService: CameraPermissionService = SystemCameraPermissionService(),
        qrCodeResolver: QRCodeResolving = DefaultQRCodeResolver()
    ) {
        self.eventRepository = eventRepository
        self.cameraPermissionService = cameraPermissionService
        self.qrCodeResolver = qrCodeResolver
    }

    func requestCameraPermission() {
        cameraPermission = cameraPermissionService.currentStatus

        guard cameraPermission == .notDetermined else {
            return
        }

        cameraPermissionService.requestAccess { [weak self] granted in
            Task { @MainActor in
                self?.cameraPermission = granted ? .authorized : .denied
            }
        }
    }

    func handleScannedData(_ rawValue: String) {
        let now = Date.now

        guard now.timeIntervalSince(lastScannedDate) > 2.0 else {
            return
        }
        guard case .idle = state else {
            return
        }

        lastScannedDate = now
        state = .loading

        Task {
            try? await Task.sleep(nanoseconds: 300_000_000)

            let existingIDs = Set(eventRepository.eventsSnapshot.map(\.id))
            let result = qrCodeResolver.resolve(
                rawValue: rawValue,
                existingIDs: existingIDs
            )

            switch result {
            case .success(let event):
                eventRepository.add(event)
                state = .success("Успешно отсканирован ваш QR-код. Хорошего времяпровождения!")
            case .duplicate:
                state = .error("Данное мероприятие уже ранее добавлено. Вы можете его найти в списке мероприятий.")
            case .failure(let message):
                state = .error(message)
            }
        }
    }

    func resetState() {
        state = .idle
    }
}
