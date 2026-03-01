//
//  EventsListController.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Combine
import Foundation

@MainActor
final class EventsListController: ObservableObject {
    @Published private(set) var state: ViewState<[Event]> = .idle
    @Published private(set) var mode: EventsMode = .active

    private let eventRepository: EventRepository
    private var cancellables: Set<AnyCancellable> = []

    init(eventRepository: EventRepository) {
        self.eventRepository = eventRepository

        eventRepository.eventsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.applyState()
            }
            .store(in: &cancellables)
    }

    func handleAppear() {
        guard case .idle = state else { return }

        state = .loading
        Task {
            try? await Task.sleep(nanoseconds: 350_000_000)
            applyState()
        }
    }

    func toggleMode() {
        mode = mode == .active ? .completed : .active
        applyState()
    }

    func displayStatus(for event: Event) -> String {
        event.status.title
    }

    /// Filters events by current mode.
    private func applyState() {
        let source = eventRepository.eventsSnapshot
        let filtered: [Event]

        switch mode {
        case .active:
            filtered = source.filter {
                $0.status.isUpcoming
            }
        case .completed:
            filtered = source.filter {
                $0.status == .completed
            }
        }

        state = filtered.isEmpty ? .empty : .success(filtered)
    }
}

enum EventsMode {
    case active
    case completed

    var toggleButtonTitle: String {
        switch self {
        case .active:
            return "Завершено"
        case .completed:
            return "Предстоящие"
        }
    }
}
