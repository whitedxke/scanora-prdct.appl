//
//  ViewState.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Foundation

enum ViewState<Value> {
    case idle
    case loading
    case empty
    case success(Value)
    case error(String)
}
