//
//  EventPersistence.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Foundation

/// Abstract storage for loading and saving events.
protocol EventStore {
    /// Loads all stored events.
    func loadEvents() throws -> [Event]
    /// Persists all provided events.
    func saveEvents(_ events: [Event]) throws
}

/// Minimal logging contract used by infrastructure components.
protocol Logger {
    /// Logs an error message.
    func error(_ message: String)
}

/// Console-based logger implementation.
struct ConsoleLogger: Logger {
    func error(_ message: String) {
        print(message)
    }
}

/// File-backed JSON event storage.
struct JSONFileEventStore: EventStore {
    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    /// Creates a JSON store for a specific file URL.
    init(
        fileURL: URL,
        encoder: JSONEncoder = JSONFileEventStore.defaultEncoder(),
        decoder: JSONDecoder = JSONFileEventStore.defaultDecoder()
    ) {
        self.fileURL = fileURL
        self.encoder = encoder
        self.decoder = decoder
    }

    /// Loads events from the configured JSON file.
    func loadEvents() throws -> [Event] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }

        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([Event].self, from: data)
    }

    /// Saves events into the configured JSON file.
    func saveEvents(_ events: [Event]) throws {
        let data = try encoder.encode(events)
        try data.write(to: fileURL, options: [.atomic])
    }
}

extension JSONFileEventStore {
    /// Factory for the app documents directory store.
    static func appDocumentsStore(fileName: String = "scanora_events.json") -> JSONFileEventStore {
        let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        return JSONFileEventStore(fileURL: url)
    }

    private static func defaultEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }

    private static func defaultDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
