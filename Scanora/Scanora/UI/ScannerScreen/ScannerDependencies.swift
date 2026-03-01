//
//  ScannerDependencies.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import AVFoundation
import Foundation

/// Service for reading and requesting camera permissions.
protocol CameraPermissionService {
    /// Current camera permission status.
    var currentStatus: CameraPermissionState { get }
    /// Requests access to the camera.
    func requestAccess(_ completion: @escaping (Bool) -> Void)
}

/// System implementation backed by `AVCaptureDevice`.
struct SystemCameraPermissionService: CameraPermissionService {
    var currentStatus: CameraPermissionState {
        CameraPermissionState.current
    }

    func requestAccess(_ completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: completion)
    }
}

/// Service for resolving raw QR strings into domain results.
protocol QRCodeResolving {
    func resolve(rawValue: String, existingIDs: Set<Int>) -> QRCodeResolutionResult
}

/// Default resolver adapter.
struct DefaultQRCodeResolver: QRCodeResolving {
    func resolve(rawValue: String, existingIDs: Set<Int>) -> QRCodeResolutionResult {
        QRCodeResolver.resolve(rawValue: rawValue, existingIDs: existingIDs)
    }
}
