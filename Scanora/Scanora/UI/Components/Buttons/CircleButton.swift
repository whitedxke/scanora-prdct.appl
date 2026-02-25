import SwiftUI

struct CircleButton<Label: View>: View {
    let action: () -> Void
    @ViewBuilder let label: () -> Label

    var body: some View {
        Button(action: action) {
            CircleIcon(label: label)
        }
        .buttonStyle(.plain)
    }
}
