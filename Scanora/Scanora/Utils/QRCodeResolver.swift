//
//  QRCodeResolver.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import CryptoKit
import Foundation

/// Resolves QR-code content into an event.
/// Attempts JSON parsing first, then falls back to hash mapping.
enum QRCodeResolver {
    /// Attempts to create an event from a QR-code string.
    static func resolve(rawValue: String, existingIDs: Set<Int>) -> QRCodeResolutionResult {
        // Attempt to parse as valid event JSON.
        if let event = resolveFromJSON(rawValue) {
            if existingIDs.contains(event.id) {
                return .duplicate
            }
            return .success(event)
        }

        // Generate event from string hash.
        let event = resolveFromHash(rawValue)
        if existingIDs.contains(event.id) {
            return .duplicate
        }
        return .success(event)
    }

    // MARK: - JSON Parsing.

    /// Attempts to parse the string as EventQRCodePayload JSON.
    private static func resolveFromJSON(_ rawValue: String) -> Event? {
        guard let data = rawValue.data(using: .utf8) else {
            return nil
        }

        guard let payload = try? JSONDecoder().decode(EventQRCodePayload.self, from: data) else {
            return nil
        }

        guard
            let id = payload.id,
            let title = payload.title, !title.isEmpty,
            let dateString = payload.date
        else {
            return nil
        }

        let date = ISO8601DateFormatter().date(from: dateString) ?? Date.now
        return Event(
            id: id,
            title: title,
            eventDescription: payload.description ?? "",
            date: date,
            image: payload.image ?? "MockAnthropicEventBanner"
        )
    }

    // MARK: - Hash Mapping.

    /// Creates an event from SHA256 hash of the string using the template pool.
    private static func resolveFromHash(_ rawValue: String) -> Event {
        let hashData = SHA256.hash(data: Data(rawValue.utf8))
        let hashBytes = Array(hashData)

        // First 8 bytes → stable UInt64 for deterministic selection.
        let idValue = hashBytes.prefix(8).enumerated().reduce(UInt64(0)) { result, pair in
            result | (UInt64(pair.element) << (pair.offset * 8))
        }

        let poolIndex = Int(idValue % UInt64(MockEventPool.count))
        let eventID = Int(idValue & 0x7FFFFFFFFFFFFFFF)
        let template = MockEventPool.templates[poolIndex]
        return Event(
            id: eventID,
            title: template.title,
            eventDescription: template.eventDescription,
            date: template.date,
            image: template.image
        )
    }
}

/// QR-code resolution result.
enum QRCodeResolutionResult {
    case success(Event)
    case duplicate
    case failure(String)
}

private struct EventQRCodePayload: Decodable {
    let id: Int?
    let title: String?
    let description: String?
    let date: String?
    let status: String?
    let image: String?
}
