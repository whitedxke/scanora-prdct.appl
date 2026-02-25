import Combine
import Foundation

@MainActor
final class EventDetailsController: ObservableObject {
    let event: Event
    @Published var isQRCodePresented = false

    init(event: Event) {
        self.event = event
    }

    func presentQRCode() {
        isQRCodePresented = true
    }
}
