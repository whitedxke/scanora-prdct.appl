import SwiftUI

struct Navigation: View {
    let eventRepository: MemoryEventRepository

    var body: some View {
        GeometryReader { proxy in
            NavigationStack {
                ScannerScene(eventRepository: eventRepository)
                    .overlay(alignment: .bottomTrailing) {
                        NavigationLink {
                            EventsListScene(eventRepository: eventRepository)
                        } label: {
                            CircleIcon {
                                Image(systemName: "list.bullet")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 24)
                        .padding(.bottom, max(24, proxy.safeAreaInsets.bottom + 12))
                    }
            }
        }
    }
}

private struct ScannerScene: View {
    @StateObject private var controller: ScannerController

    init(eventRepository: MemoryEventRepository) {
        _controller = StateObject(
            wrappedValue: ScannerController(eventRepository: eventRepository),
        )
    }

    var body: some View {
        ScannerScreen(controller: controller)
    }
}

private struct EventsListScene: View {
    @StateObject private var controller: EventsListController

    init(eventRepository: MemoryEventRepository) {
        _controller = StateObject(
            wrappedValue: EventsListController(eventRepository: eventRepository),
        )
    }

    var body: some View {
        EventsListScreen(controller: controller)
    }
}
