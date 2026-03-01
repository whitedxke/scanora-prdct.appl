//
//  EventRepository.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Combine
import Foundation

/// Event repository contract.
protocol EventRepository: AnyObject {
    /// Current snapshot of all events.
    var eventsSnapshot: [Event] { get }

    /// Publisher for event list changes.
    var eventsPublisher: AnyPublisher<[Event], Never> { get }

    /// Adds an event to the storage.
    func add(_ event: Event)

    /// Checks whether an event with the specified identifier exists.
    func containsEvent(withID id: Int) -> Bool
}
