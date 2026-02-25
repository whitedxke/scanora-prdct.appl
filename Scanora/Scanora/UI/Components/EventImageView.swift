import SwiftUI

struct EventImageView: View {
    let imageURL: URL?
    let assetName: String?
    let height: CGFloat
    let fillsWidth: Bool

    init(imageURL: URL?, assetName: String? = nil, height: CGFloat, fillsWidth: Bool = true) {
        self.imageURL = imageURL
        self.assetName = assetName
        self.height = height
        self.fillsWidth = fillsWidth
    }

    var body: some View {
        Group {
            if let imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .empty, .failure:
                        placeholder
                    @unknown default:
                        placeholder
                    }
                }
            } else if let assetName {
                Image(assetName)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
            }
        }
        .frame(maxWidth: fillsWidth ? .infinity : nil)
        .frame(height: height)
        .background(Color.gray.opacity(0.12))
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    private var placeholder: some View {
        ZStack {
            Color.gray.opacity(0.12)
            Image(systemName: "photo")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(.gray)
        }
    }
}
