import Combine
import Foundation

@MainActor
final class ScannerController: ObservableObject {
    @Published private(set) var state: ApplicationViewState<String> = .idle

    private let eventRepository: EventRepositoryType

    init(eventRepository: EventRepositoryType) {
        self.eventRepository = eventRepository
    }

    func reset() {
        state = .idle
    }

    func mockScanFromTitleTap() {
        state = .loading

        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)

            let success = Int.random(in: 1...100) <= 85

            guard success else {
                state = .error("QR-код не распознан")
                return
            }

            let randomStatus = EventStatus.allCases.randomElement() ?? .upcoming
            let fixedDate = DateComponents(
                calendar: Calendar(identifier: .gregorian),
                year: 1998,
                month: 10,
                day: 4,
                hour: 9,
                minute: 50
            ).date ?? Date()

            let event = Event(
                id: Int.random(in: 1...100_000),
                title: "Code with Claude",
                eventDescription: """
Code with Claude will offer interactive workshops centered on real-world applications, helping you make the most of frontier AI.

You’ll hear directly from Anthropic’s executive and product teams, participate in interactive labs and sessions, meet our technical teams during office hours, and connect with a community of developers building with Claude.

The conference will showcase how developers are maximizing Claude’s capabilities across our models, products, and API. You'll learn about our product roadmap, Claude Code, MCP, development methodologies, AI agent implementation strategies, and tool use patterns from the technical teams building Claude-powered applications at leading companies.
""",
                date: fixedDate,
                status: randomStatus,
                image: "EventMockBanner"
            )

            eventRepository.add(event)
            state = .success("Мероприятие добавлено")
        }
    }
}
