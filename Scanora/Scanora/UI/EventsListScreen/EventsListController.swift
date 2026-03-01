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
    @Published private(set) var state: ApplicationViewState<[Event]> = .idle
    @Published private(set) var mode: EventsMode = .active

    private let eventProtocolRepository: EventProtocolRepository
    private var cancellables: Set<AnyCancellable> = []

    init(eventRepository: EventProtocolRepository) {
        self.eventProtocolRepository = eventRepository

        eventRepository.onEventsPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.onApplyState()
            }
            .store(in: &cancellables)
    }

    func onAppear() {
        guard case .idle = state else {
            return
        }
        
        state = .loading
        Task {
            try? await Task.sleep(nanoseconds: 350_000_000)
            onApplyState()
        }
    }

    func onToggleMode() {
        mode = mode == .active ? .completed : .active
        onApplyState()
    }

    func onDisplayStatus(for event: Event) -> String {
        event.status.title
    }

    /// Filters events by current mode.
    private func onApplyState() {
        let source = eventProtocolRepository.onEventsSnapshot
        let filtered: [Event]

        switch mode {
        case .active:
            filtered = source.filter {
                $0.status.isActive
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

    var switchButtonTitle: String {
        switch self {
        case .active:
            return "Завершено"
        case .completed:
            return "Предстоящие"
        }
    }
}
