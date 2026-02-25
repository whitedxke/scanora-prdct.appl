import SwiftUI

struct EventsListScreen: View {
    @ObservedObject var controller: EventsListController

    var body: some View {
        VStack(spacing: 16) {
            header

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            controller.onAppear()
        }
    }

    private var header: some View {
        HStack {
            Spacer()

            Button(controller.mode.switchButtonTitle) {
                controller.toggleMode()
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .lineLimit(1)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.black.opacity(0.82))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.top, 24)
        }
        .padding(.horizontal, 24)
    }

    @ViewBuilder
    private var content: some View {
        switch controller.state {
        case .idle, .loading:
            ProgressView("Загрузка мероприятий")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .empty:
            VStack(spacing: 12) {
                Image(systemName: "calendar.badge.exclamationmark")
                    .font(.system(size: 42))
                    .foregroundStyle(.secondary)
                Text("У вас нет мероприятий")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .error(let message):
            Text(message)
                .foregroundStyle(.red)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .success(let events):
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(events) { event in
                        NavigationLink {
                            EventDetailsScreen(event: event)
                        } label: {
                            EventCard(
                                event: event,
                                displayStatus: controller.displayStatus(for: event)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 16)
        }
    }
}

private struct EventCard: View {
    let event: Event
    let displayStatus: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            EventImageView(imageURL: event.imageURL, assetName: event.imageAssetName, height: 160)

            VStack(alignment: .leading, spacing: 0) {
                Text(event.title)
                    .font(.headline)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .padding(.top, 12)

                Text(displayStatus)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.pink)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.pink, lineWidth: 1)
                    )
                    .padding(.top, 4)

                Text(event.date.eventDisplayText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 16)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
