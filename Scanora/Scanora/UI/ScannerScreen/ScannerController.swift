//
//  ScannerController.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import AVFoundation
import Combine
import Foundation

@MainActor
final class ScannerController: ObservableObject {
    @Published private(set) var state: ApplicationViewState<String> = .idle
    @Published private(set) var cameraPermission: CameraPermissionState = .notDetermined

    var isScanning: Bool {
        if case .idle = state {
            return cameraPermission == .authorized
        }
        
        return false
    }

    private let eventProtocolRepository: EventProtocolRepository
    private var lastScannedDate: Date = .distantPast

    init(eventProtocolRepository: EventProtocolRepository) {
        self.eventProtocolRepository = eventProtocolRepository
    }

    func onRequestCameraPermission() {
        cameraPermission = CameraPermissionState.current

        guard cameraPermission == .notDetermined else {
            return
        }

        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            Task { @MainActor in
                self?.cameraPermission = granted ? .authorized : .denied
            }
        }
    }

    func onHandleScannedData(_ rawValue: String) {
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

            let existingIDs = Set(
                eventProtocolRepository.onEventsSnapshot.map(\.id),
            )
            let result = QRCodeResolver.resolve(
                rawValue: rawValue,
                existingIDs: existingIDs
            )

            switch result {
            case .success(let event):
                eventProtocolRepository.onAdd(event)
                state = .success("Успешно отсканирован ваш QR-код. Хорошего времяпровождения!")
            case .duplicate:
                state = .error("Данное мероприятие уже ранее добавлено. Вы можете его найти в списке мероприятий.")
            case .failure(let message):
                state = .error(message)
            }
        }
    }

    func onDispose() {
        state = .idle
    }
}
