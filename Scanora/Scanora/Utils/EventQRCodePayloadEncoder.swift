//
//  EventQRCodePayloadEncoder.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Foundation

/// Encodes an event into a QR payload string.
protocol EventQRCodePayloadEncoding {
    /// Returns an encoded payload string for a given event.
    func encode(_ event: Event) -> String
}

/// JSON implementation of `EventQRCodePayloadEncoding`.
struct JSONEventQRCodePayloadEncoder: EventQRCodePayloadEncoding {
    private let dateFormatter = ISO8601DateFormatter()

    /// Encodes event fields into a stable JSON string.
    func encode(_ event: Event) -> String {
        let payload: [String: Any] = [
            "id": event.id,
            "title": event.title,
            "description": event.eventDescription,
            "date": dateFormatter.string(from: event.date),
            "image": event.image
        ]

        guard
            let data = try? JSONSerialization.data(withJSONObject: payload, options: [.sortedKeys]),
            let json = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }

        return json
    }
}
