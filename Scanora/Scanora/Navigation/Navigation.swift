//
//  Navigation.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import SwiftUI

struct AppNavigation: View {
    let eventRepository: any EventRepository

    var body: some View {
        GeometryReader { proxy in
            NavigationStack {
                ScannerScene(eventRepository: eventRepository)
                    .overlay(alignment: .bottomTrailing) {
                        NavigationLink {
                            EventsListScene(eventRepository: eventRepository)
                        } label: {
                            CircleIcon {
                                Image(systemName: "list.bullet")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 24)
                        .padding(.bottom, max(24, proxy.safeAreaInsets.bottom + 12))
                    }
            }
        }
    }
}

/// Scanner scene with its own controller.
private struct ScannerScene: View {
    @StateObject private var controller: ScannerController

    init(eventRepository: any EventRepository) {
        _controller = StateObject(
            wrappedValue: ScannerController(eventRepository: eventRepository)
        )
    }

    var body: some View {
        ScannerScreen(controller: controller)
    }
}

/// Events list scene with its own controller.
private struct EventsListScene: View {
    @StateObject private var controller: EventsListController

    init(eventRepository: any EventRepository) {
        _controller = StateObject(
            wrappedValue: EventsListController(eventRepository: eventRepository)
        )
    }

    var body: some View {
        EventsListScreen(controller: controller)
    }
}
