//
//  Event.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Foundation

struct Event: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let eventDescription: String
    let date: Date
    let image: String

    /// Status is computed dynamically based on the event date.
    var status: EventStatus {
        date > Date.now ? .upcoming : .completed
    }

    // MARK: - Codable.

    /// Excludes the computed property `status` from encoding.
    private enum CodingKeys: String, CodingKey {
        case id, title, eventDescription, date, image
    }

    // MARK: - Hashable & Equatable.

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.id == rhs.id
            && lhs.title == rhs.title
            && lhs.eventDescription == rhs.eventDescription
            && lhs.date == rhs.date
            && lhs.image == rhs.image
    }

    // MARK: - Image.

    /// Image URL if the `image` string contains a valid HTTP link.
    var imageURL: URL? {
        guard
            let url = URL(string: image),
            let scheme = url.scheme?.lowercased(),
            scheme == "http" || scheme == "https"
        else {
            return nil
        }

        return url
    }

    /// Asset name from the catalog if `image` is not a URL.
    var imageAssetName: String? {
        guard imageURL == nil, !image.isEmpty else {
            return nil
        }
        
        if image == "event_mock_banner" {
            return "MockAnthropicEventBanner"
        }

        return image
    }

    // MARK: - QR-Code.

    /// JSON string for encoding event data into a QR code.
    var qrPayloadJSONString: String {
        let payload: [String: Any] = [
            "id": id,
            "title": title,
            "description": eventDescription,
            "date": ISO8601DateFormatter().string(from: date),
            "image": image
        ]

        guard
            let data = try? JSONSerialization.data(
                withJSONObject: payload,
                options: [.sortedKeys],
            ),
            let json = String(data: data, encoding: .utf8)
        else {
            return "{}"
        }

        return json
    }
}

/// QR-code data structure for decoding event data.
struct EventQRPayload: Decodable {
    let id: Int?
    let title: String?
    let description: String?
    let date: String?
    let status: String?
    let image: String?
}
