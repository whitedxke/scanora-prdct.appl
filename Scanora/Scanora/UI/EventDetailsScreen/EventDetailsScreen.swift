//
//  EventDetailsScreen.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import SwiftUI

struct EventDetailsScreen: View {
    @StateObject private var controller: EventDetailsController

    init(event: Event) {
        _controller = StateObject(wrappedValue: EventDetailsController(event: event))
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    EventImageView(imageURL: controller.event.imageURL, assetName: controller.event.imageAssetName, height: 220)
                        .frame(
                            width: max(0, proxy.size.width - 32),
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12, style: .continuous),
                        )
                    Text(controller.event.title)
                        .font(
                            .title2.weight(.bold),
                        )
                        .padding(.top, 16)
                    Text(controller.event.status.title)
                        .font(
                            .subheadline.weight(.semibold),
                        )
                        .foregroundStyle(.pink)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(
                                    Color.pink, lineWidth: 1,
                                )
                        )
                        .padding(.top, 12)
                    Text(controller.event.date.eventDisplayText)
                        .foregroundStyle(.secondary)
                        .padding(.top, 16)
                    Text(controller.event.eventDescription)
                        .font(.body)
                        .padding(.top, 32)
                }
                .frame(
                    width: max(0, proxy.size.width - 32),
                    alignment: .leading,
                )
                .padding(.vertical, 16)
            }
            .frame(maxWidth: .infinity)
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("Детали")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: Alignment.bottomTrailing) {
            CircleButton {
                controller.onPresentQRCode()
            } label: {
                Image(systemName: "qrcode")
                    .font(
                        .system(size: 20, weight: .semibold),
                    )
                    .foregroundStyle(.secondary)
            }
            .padding(.trailing, 24)
            .padding(.bottom, 24)
        }
        .sheet(isPresented: $controller.isQRCodePresented) {
            EventQRCodeView(event: controller.event)
                .presentationDetents([.medium, .large])
        }
    }
}
