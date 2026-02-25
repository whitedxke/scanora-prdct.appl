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
                        .contentShape(Rectangle())
                        .onTapGesture {
                            controller.mockScanFromTitleTap()
                        }

                    Spacer()
                }
                .padding(.top, 32)
                .padding(.horizontal, 24)

                Spacer(minLength: 0)

                statusCard
                    .frame(width: qrSide, height: qrSide)
                    .padding(.horizontal, 24)

                Button("Сброс") {
                    controller.reset()
                }
                .buttonStyle(.plain)

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    @ViewBuilder
    private var statusCard: some View {
        switch controller.state {
        case .idle:
            baseCard(icon: "qrcode.viewfinder", text: "Пожалуйста, отсканируйте QR-код", color: .primary)
        case .loading:
            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)
                Text("Обработка")
                    .font(.body)
                    .multilineTextAlignment(.center)
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        case .success(let message):
            baseCard(icon: "checkmark.circle.fill", text: message, color: .green)
        case .error(let message):
            baseCard(icon: "xmark.circle.fill", text: message, color: .red)
        case .empty:
            baseCard(icon: "tray", text: "Пусто", color: .primary)
        }
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
