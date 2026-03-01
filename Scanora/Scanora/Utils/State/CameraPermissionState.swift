//
//  CameraPermissionState.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import AVFoundation

enum CameraPermissionState {
    case notDetermined
    case authorized
    case denied

    static var current: CameraPermissionState {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return .authorized
        case .notDetermined:
            return .notDetermined
        case .denied, .restricted:
            return .denied
        @unknown default:
            return .denied
        }
    }
}
