//
//  QRScannerView.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import SwiftUI

/// SwiftUI wrapper for QR-code scanning camera.
struct QRScannerView: UIViewControllerRepresentable {
    let isScanning: Bool
    let onScan: (String) -> Void

    func makeUIViewController(context: Context) -> QRScannerViewController {
        let controller = QRScannerViewController()
        controller.delegate = context.coordinator
        
        return controller
    }

    func updateUIViewController(_ uiViewController: QRScannerViewController, context: Context) {
        if isScanning {
            uiViewController.onStart()
        } else {
            uiViewController.onStop()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onScanned: onScan)
    }

    /// Coordinator connecting the UIKit delegate with the SwiftUI closure.
    final class Coordinator: NSObject, QRScannerDelegate {
        let onScan: (String) -> Void

        init(onScanned: @escaping (String) -> Void) {
            self.onScan = onScanned
        }

        func onScan(value: String) {
            onScan(value)
        }
    }
}
