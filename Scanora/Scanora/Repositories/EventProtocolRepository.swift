//
//  EventProtocolRepository.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Combine
import Foundation

/// Event protocol repository.
protocol EventProtocolRepository: AnyObject {
    /// Current snapshot of all events.
    var onEventsSnapshot: [Event] {
        get
    }

    /// Publisher for event list changes.
    var onEventsPublisher: AnyPublisher<[Event], Never> {
        get
    }

    /// Adds an event to the storage.
    func onAdd(_ event: Event)

    /// Checks whether an event with the specified identifier exists.
    func onContain(id: Int) -> Bool
}
