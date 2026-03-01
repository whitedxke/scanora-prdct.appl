//
//  EventImageResourceResolver.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Foundation

/// Represents the resolved image source for an event.
struct EventImageResource {
    /// Remote image URL when the original value is a valid HTTP(S) link.
    let remoteURL: URL?
    /// Local asset name when the original value points to an asset.
    let assetName: String?
}

/// Resolves a raw image string into either a remote URL or an asset name.
enum EventImageResourceResolver {
    /// Resolves image data from a raw backend value.
    static func resolve(from rawImageValue: String) -> EventImageResource {
        if
            let url = URL(string: rawImageValue),
            let scheme = url.scheme?.lowercased(),
            scheme == "http" || scheme == "https"
        {
            return EventImageResource(remoteURL: url, assetName: nil)
        }

        guard !rawImageValue.isEmpty else {
            return EventImageResource(remoteURL: nil, assetName: nil)
        }

        if rawImageValue == "event_mock_banner" {
            return EventImageResource(remoteURL: nil, assetName: "MockAnthropicEventBanner")
        }

        return EventImageResource(remoteURL: nil, assetName: rawImageValue)
    }
}
