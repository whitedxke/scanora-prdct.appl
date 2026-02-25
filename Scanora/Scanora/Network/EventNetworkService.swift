import Foundation

protocol EventNetworkServiceType {
    func fetchEvents() async throws -> [Event]
}

struct MockEventNetworkService: EventNetworkServiceType {
    func fetchEvents() async throws -> [Event] {
        []
    }
}
