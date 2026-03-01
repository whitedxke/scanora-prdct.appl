//
//  CircleButton.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import SwiftUI

struct CircleButton<Label: View>: View {
    let action: () -> Void
    @ViewBuilder let label: () -> Label

    var body: some View {
        Button(action: action) {
            CircleIcon(label: label)
        }
        .buttonStyle(.plain)
    }
}
