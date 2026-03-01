//
//  ApplicationViewState.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Foundation

enum ApplicationViewState<T> {
    case idle
    case loading
    case empty
    case success(T)
    case error(String)
}
