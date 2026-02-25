import Foundation

struct Event: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let eventDescription: String
    let date: Date
    let status: EventStatus
    let image: String

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

    var imageAssetName: String? {
        guard imageURL == nil, !image.isEmpty else { return nil }
        if image == "event_mock_banner" {
            return "EventMockBanner"
        }
        
        return image
    }

    var qrPayloadJSONString: String {
        let payload: [String: Any] = [
            "id": id,
            "title": title,
            "description": eventDescription,
            "date": ISO8601DateFormatter().string(from: date),
            "status": status.rawValue,
            "image": image
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

struct EventQRPayload: Decodable {
    let id: Int?
    let title: String?
    let description: String?
    let date: String?
    let status: String?
    let image: String?
}
