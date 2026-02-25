import CoreImage.CIFilterBuiltins
import SwiftUI

struct EventQRCodeView: View {
    let event: Event

    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()

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

    private var qrImage: Image {
        guard
            let data = event.qrPayloadJSONString.data(using: .utf8)
        else {
            return Image(systemName: "qrcode")
        }

        filter.setValue(data, forKey: "inputMessage")

        guard
            let outputImage = filter.outputImage,
            let cgImage = context.createCGImage(outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10)), from: outputImage.extent)
        else {
            return Image(systemName: "qrcode")
        }

        return Image(decorative: cgImage, scale: 1.0)
    }
}
