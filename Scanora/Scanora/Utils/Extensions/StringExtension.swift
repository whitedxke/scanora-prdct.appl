//
//  StringExtension.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Foundation

extension Optional where Wrapped == String {
    var orEmpty: String {
        self ?? ""
    }
}
