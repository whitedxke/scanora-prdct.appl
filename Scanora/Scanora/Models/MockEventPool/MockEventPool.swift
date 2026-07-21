//
//  MockEventPool.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Foundation

/// A pool of event templates for generating arbitrary QR-codes.
enum MockEventPool {
    /// Event template without an identifier.
    struct Template {
        let title: String
        let eventDescription: String
        let date: Date
        let image: String
    }

    /// An array of predefined event templates.
    static let templates: [Template] = {
        let formatter = ISO8601DateFormatter()

        /// Auxiliary function for creating a date from a string.
        func makeDate(_ isoString: String) -> Date {
            formatter.date(from: isoString) ?? Date.now
        }

        return [
            // MARK: - Dxke Events.

            Template(
                title: "Code with Dxke",
                eventDescription: """
                Join us at the event to find out what the Dxke teams are working on and stay up to date on the latest news.
                """,
                date: makeDate("2026-07-21T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "AI-Summit Minsk",
                eventDescription: """
                White Dxke's AI-Summit in Minsk — a technical event for startup developers. Get a first look at new features and learn how to integrate with external services.
                """,
                date: makeDate("2026-07-21T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "AI-Summit Brest",
                eventDescription: """
                White Dxke's AI-Summit in Brest — a technical event for startup developers. Get a first look at new features and learn how to integrate with external services.
                """,
                date: makeDate("2026-06-20T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "AI-Summit Grodno",
                eventDescription: """
                White Dxke's AI-Summit in Grodno — a technical event for startup developers. Get a first look at new features and learn how to integrate with external services.
                """,
                date: makeDate("2026-08-10T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "Healthcare and Life Sciences",
                eventDescription: """
                Teams in healthcare and the life sciences need AI that is accurate enough to be entrusted with real research and patient care.

                Join the live stream with leaders who are tackling this very challenge.

                What's in store for you?
                • How AI is being applied in healthcare scenarios.
                • The experience of partner organizations.
                • Examples of AI applications in healthcare.
                """,
                date: makeDate("2026-10-25T00:00:00Z"),
                image: "MockAnthropicEventBanner"
            ),

            Template(
                title: "Dxke for Software Engineers",
                eventDescription: """
                Technical overview of Dxke — an AI-powered code-writing agent that helps develop functions, debug code, run tests, and navigate large codebases. We'll show how engineering teams use it to accelerate their day-to-day development work.

                Expect answers to questions about the repository and processes such as refactoring and writing tests. This is suitable for anyone evaluating how an AI code-writing agent might fit into their team's workflows.
                """,
                date: makeDate("2027-11-05T00:00:00Z"),
                image: ""
            ),

            Template(
                title: "Introduction to Dxke",
                eventDescription: """
                An overview of Dxke — a code generation system — for beginners. We'll explain what it is, break down everyday tasks, and show how even non-technical professionals can start benefiting from it today. No programming experience is required.
                """,
                date: makeDate("2027-12-15T00:00:00Z"),
                image: ""
            )
        ]
    }()

    static var count: Int {
        templates.count
    }
}
