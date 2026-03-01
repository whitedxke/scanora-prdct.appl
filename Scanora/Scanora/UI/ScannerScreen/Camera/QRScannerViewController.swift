//
//  QRScannerViewController.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import AVFoundation
import UIKit

final class QRScannerViewController: UIViewController {
    weak var delegate: QRScannerDelegate?

    private let captureSession = AVCaptureSession()
    private let captureMetadataOutput = AVCaptureMetadataOutput()
    private var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer?
    private let metadataDelegate = MetadataDelegate()
    private var isSessionConfigured = false

    override func viewDidLoad() {
        view.backgroundColor = .black
        metadataDelegate.onDetected = { [weak self] value in
            Task { @MainActor in
                self?.delegate?.onScan(value: value)
            }
        }
        
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        captureVideoPreviewLayer?.frame = view.bounds
        
        super.viewDidLayoutSubviews()
    }

    /// Configures and starts a camera capture session.
    func onStart() {
        guard !isSessionConfigured else {
            if !captureSession.isRunning {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    self?.captureSession.startRunning()
                }
            }
            return
        }

        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device)
        else {
            return
        }

        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }

        if captureSession.canAddOutput(captureMetadataOutput) {
            captureSession.addOutput(captureMetadataOutput)
        }

        let queue = DispatchQueue(label: "co.whitedxke.Scanora.qrscanner")
        captureMetadataOutput.setMetadataObjectsDelegate(metadataDelegate, queue: queue)

        if captureMetadataOutput.availableMetadataObjectTypes.contains(.qr) {
            captureMetadataOutput.metadataObjectTypes = [.qr]
        }

        let layer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.videoGravity = .resizeAspectFill
        layer.frame = view.bounds
        view.layer.addSublayer(layer)
        captureVideoPreviewLayer = layer

        isSessionConfigured = true

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    /// Stops the camera capture session.
    func onStop() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.stopRunning()
        }
    }
}

/// A delegate receiving the result of scanning a QR-code.
protocol QRScannerDelegate: AnyObject {
    @MainActor func onScan(value: String)
}

// MARK: - MetadataDelegate.

/// Camera metadata processor. Isolated from MainActor to run in a background thread.
private final class MetadataDelegate: NSObject,
    @preconcurrency AVCaptureMetadataOutputObjectsDelegate
{
    nonisolated(unsafe) var onDetected: ((String) -> Void)?

    nonisolated func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let readableObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let stringValue = readableObject.stringValue,
              !stringValue.isEmpty
        else {
            return
        }

        onDetected?(stringValue)
    }
}
