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
}
