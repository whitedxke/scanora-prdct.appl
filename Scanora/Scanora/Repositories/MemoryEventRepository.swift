import Combine
import Foundation

protocol EventRepositoryType: AnyObject {
    var eventsSnapshot: [Event] {
        get
    }
    var eventsPublisher: AnyPublisher<[Event], Never> {
        get
    }
    
    func add(_ event: Event)
}

final class MemoryEventRepository: ObservableObject, EventRepositoryType {
    @Published private(set) var events: [Event] = []

    var eventsSnapshot: [Event] {
        events
    }
    var eventsPublisher: AnyPublisher<[Event], Never> {
        $events.eraseToAnyPublisher()
    }

    func add(_ event: Event) {
        events.append(event)
    }
}
