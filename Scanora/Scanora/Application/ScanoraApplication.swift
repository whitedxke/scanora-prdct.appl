import SwiftUI

@main
struct ScanoraApplication: App {
    @StateObject private var eventRepository = MemoryEventRepository()

    var body: some Scene {
        WindowGroup {
            Navigation(
                eventRepository: eventRepository,
            )
        }
    }
}
