//
//  PersistentEventRepository.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Combine
import Foundation

/// Event storage with file system persistence (JSON).
final class PersistentEventRepository: ObservableObject, EventRepository {
    @Published private(set) var events: [Event] = []

    private let store: EventStore
    private let logger: Logger

    var eventsSnapshot: [Event] { events }

    var eventsPublisher: AnyPublisher<[Event], Never> {
        $events.eraseToAnyPublisher()
    }

    init(
        store: EventStore = JSONFileEventStore.appDocumentsStore(),
        logger: Logger = ConsoleLogger()
    ) {
        self.store = store
        self.logger = logger
        events = load()
    }

    /// Adds an event and saves to disk.
    func add(_ event: Event) {
        events.append(event)
        save()
    }

    /// Checks whether an event with the given id exists.
    func containsEvent(withID id: Int) -> Bool {
        events.contains(where: { $0.id == id })
    }

    // MARK: - Persistence.

    private func save() {
        do {
            try store.saveEvents(events)
        } catch {
            logger.error("[PersistentEventRepository] Save error: \(error).")
        }
    }

    private func load() -> [Event] {
        do {
            return try store.loadEvents()
        } catch {
            logger.error("[PersistentEventRepository] Load error: \(error).")
            return []
        }
    }
}
