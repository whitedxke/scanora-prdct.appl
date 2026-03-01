//
//  CircleIcon.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import SwiftUI

struct CircleIcon<Label: View>: View {
    let size: CGFloat
    @ViewBuilder let label: () -> Label

    init(size: CGFloat = 48, @ViewBuilder label: @escaping () -> Label) {
        self.size = size
        self.label = label
    }

    var body: some View {
        label()
            .frame(width: size, height: size)
            .background(.ultraThinMaterial, in: Circle())
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.45), lineWidth: 0.8)
            )
            .shadow(
                color: .black.opacity(0.16),
                radius: 8,
                x: 0,
                y: 3
            )
    }
}
