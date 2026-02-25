import Combine
import Foundation

enum EventsMode {
    case active
    case completed

    var switchButtonTitle: String {
        switch self {
        case .active:
            return "Завершено"
        case .completed:
            return "Предстоящие"
        }
    }
}

@MainActor
final class EventsListController: ObservableObject {
    @Published private(set) var state: ApplicationViewState<[Event]> = .idle
    @Published private(set) var mode: EventsMode = .active

    private let eventRepository: EventRepositoryType
    private var cancellables: Set<AnyCancellable> = []

    init(eventRepository: EventRepositoryType) {
        self.eventRepository = eventRepository

        eventRepository.eventsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.applyCurrentState()
            }
            .store(in: &cancellables)
    }

    func onAppear() {
        guard case .idle = state else { return }
        state = .loading

        Task {
            try? await Task.sleep(nanoseconds: 350_000_000)
            applyCurrentState()
        }
    }

    func toggleMode() {
        mode = mode == .active ? .completed : .active
        applyCurrentState()
    }

    func displayStatus(for event: Event) -> String {
        event.status.title
    }

    private func applyCurrentState() {
        let source = eventRepository.eventsSnapshot
        let filtered: [Event]

        switch mode {
        case .active:
            filtered = source.filter { $0.status.isActive }
        case .completed:
            filtered = source.filter { $0.status == .completed }
        }

        state = filtered.isEmpty ? .empty : .success(filtered)
    }
}
