//
//  EventDetailsController.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Combine
import Foundation

@MainActor
final class EventDetailsController: ObservableObject {
    let event: Event
    @Published var isQRCodePresented = false

    init(event: Event) {
        self.event = event
    }

    func presentQRCode() {
        isQRCodePresented = true
    }
}
