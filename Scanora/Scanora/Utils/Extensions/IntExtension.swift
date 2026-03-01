//
//  IntExtension.swift
//  Scanora
//
//  Created by Pavel Betenya on 28.02.26.
//

import Foundation

extension Optional where Wrapped == Int {
    var orZero: Int {
        self ?? -1
    }
}
