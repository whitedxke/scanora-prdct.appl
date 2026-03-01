//
//  ScannerScreen.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import SwiftUI

struct ScannerScreen: View {
    @ObservedObject var controller: ScannerController

    var body: some View {
        GeometryReader { geometry in
            let qrSide = min(geometry.size.width - 48, geometry.size.height * 0.66)

            VStack(spacing: 24) {
                HStack {
                    Text("Сканер")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .padding(.top, 32)
                .padding(.horizontal, 24)
                Spacer(minLength: 0)
                cameraStatusView(qrSide: qrSide)
                    .frame(width: qrSide, height: qrSide)
                    .padding(.horizontal, 24)
                if !controller.isScanning {
                    Button("Сброс") {
                        controller.resetState()
                    }
                    .buttonStyle(.plain)
                }
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            controller.requestCameraPermission()
        }
    }

    // MARK: - Camera and states.

    /// Displays the camera or status depending on the resolution.
    @ViewBuilder
    private func cameraStatusView(qrSide: CGFloat) -> some View {
        switch controller.cameraPermission {
        case .notDetermined:
            baseCard(
                icon: "camera",
                text: "Запрашиваем доступ к камере...",
                color: .secondary
            )
        case .denied:
            baseCard(
                icon: "camera.badge.exclamationmark",
                text: "Доступ к камере запрещён. Разрешите в настройках.",
                color: .red
            )
        case .authorized:
            ZStack {
                QRScannerView(
                    isScanning: controller.isScanning,
                    onScan: { value in
                        controller.handleScannedData(value)
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
                statusOverlay
            }
        }
    }

    @ViewBuilder
    private var statusOverlay: some View {
        switch controller.state {
        case .idle:
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.6), lineWidth: 2)
        case .loading:
            loadingOverlay
        case .success(let message):
            overlayCard(
                icon: "checkmark.circle.fill",
                text: message,
                color: .green
            )
        case .error(let message):
            overlayCard(
                icon: "xmark.circle.fill",
                text: message,
                color: .red
            )
        case .empty:
            EmptyView()
        }
    }

    private var loadingOverlay: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(.white)
            Text("Обработка")
                .font(.body)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func overlayCard(icon: String, text: String, color: Color) -> some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 56, weight: .regular))
                .foregroundStyle(color)
            Text(text)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func baseCard(icon: String, text: String, color: Color) -> some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 56, weight: .regular))
                .foregroundStyle(color)
            Text(text)
                .font(.body)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .foregroundStyle(color)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
