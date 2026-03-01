//
//  MemoryEventRepository.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Combine
import Foundation

/// In-memory event storage.
final class MemoryEventRepository: ObservableObject, EventRepository {
    @Published private(set) var events: [Event] = []

    var eventsSnapshot: [Event] {
        events
    }

    var eventsPublisher: AnyPublisher<[Event], Never> {
        $events.eraseToAnyPublisher()
    }

    /// Adds an event to the array.
    func add(_ event: Event) {
        events.append(event)
    }

    /// Checks whether an event with the given id exists.
    func containsEvent(withID id: Int) -> Bool {
        events.contains(where: { $0.id == id })
    }
}
