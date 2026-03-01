//
//  MemoryEventRepository.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Combine
import Foundation

/// In-memory event storage.
final class MemoryEventRepository: ObservableObject, EventProtocolRepository {
    @Published private(set) var events: [Event] = []

    var onEventsSnapshot: [Event] {
        events
    }

    var onEventsPublisher: AnyPublisher<[Event], Never> {
        $events.eraseToAnyPublisher()
    }

    /// Adds an event to the array.
    func onAdd(_ event: Event) {
        events.append(event)
    }

    /// Checks whether an event with the given id exists.
    func onContain(id: Int) -> Bool {
        events.contains(where: { $0.id == id })
    }
}
