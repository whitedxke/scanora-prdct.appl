//
//  PersistentEventRepository.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Combine
import Foundation

/// Event storage with file system persistence (JSON).
final class PersistentEventRepository: ObservableObject, EventProtocolRepository {
    @Published private(set) var events: [Event] = []

    private static let fileName = "scanora_events.json"

    var onEventsSnapshot: [Event] { events }

    var onEventsPublisher: AnyPublisher<[Event], Never> {
        $events.eraseToAnyPublisher()
    }

    init() {
        events = Self.onLoad()
    }

    /// Adds an event and saves to disk.
    func onAdd(_ event: Event) {
        events.append(event)
        onSave()
    }

    /// Checks whether an event with the given id exists.
    func onContain(id: Int) -> Bool {
        events.contains(
            where: {
                $0.id == id
            },
        )
    }

    // MARK: - File System Operations.

    /// Path to the storage file.
    private static var fileURL: URL {
        FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
    }

    /// Saves the current events array to disk.
    private func onSave() {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(events)
            try data.write(
                to: Self.fileURL,
                options: [.atomic],
            )
        } catch {
            print("[PersistentEventRepository] Save error: \(error).")
        }
    }

    /// Loads the events array from disk.
    private static func onLoad() -> [Event] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(
                [Event].self,
                from: data,
            )
        } catch {
            print("[PersistentEventRepository] Load error: \(error).")
            return []
        }
    }
}
