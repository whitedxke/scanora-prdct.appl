//
//  EventQRCodeView.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import CoreImage.CIFilterBuiltins
import SwiftUI

struct EventQRCodeView: View {
    let event: Event
    private let payloadEncoder: EventQRCodePayloadEncoding

    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

    init(event: Event, payloadEncoder: EventQRCodePayloadEncoding = JSONEventQRCodePayloadEncoder()) {
        self.event = event
        self.payloadEncoder = payloadEncoder
    }

    var body: some View {
        VStack {
            Spacer()
            qrImage
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(maxWidth: 280, maxHeight: 280)
                .padding(16)
                .background(Color.white, in: RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .ignoresSafeArea(.container, edges: .bottom)
    }

    /// Generates a QR code from event JSON data.
    private var qrImage: Image {
        let payload = payloadEncoder.encode(event)
        guard let data = payload.data(using: .utf8) else {
            return Image(systemName: "qrcode")
        }

        filter.setValue(data, forKey: "inputMessage")

        guard let outputImage = filter.outputImage else {
            return Image(systemName: "qrcode")
        }

        let scaledImage = outputImage.transformed(
            by: CGAffineTransform(scaleX: 10, y: 10)
        )

        guard let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) else {
            return Image(systemName: "qrcode")
        }

        return Image(decorative: cgImage, scale: 1.0)
    }
}
