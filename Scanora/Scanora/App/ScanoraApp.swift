//
//  ScanoraApp.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import SwiftUI

/// Entry point of the Scanora application.
@main
struct ScanoraApp: App {
    @StateObject private var persistentEventRepository = PersistentEventRepository()

    var body: some Scene {
        WindowGroup {
            AppNavigation(
                eventRepository: persistentEventRepository
            )
        }
    }
}
