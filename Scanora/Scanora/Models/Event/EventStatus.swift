//
//  EventStatus.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Foundation

enum EventStatus: String, Codable, CaseIterable {
    case upcoming
    case completed

    var title: String {
        switch self {
        case .upcoming:
            return "Предстоящие"
        case .completed:
            return "Завершено"
        }
    }

    var isActive: Bool {
        self == .upcoming
    }
}
