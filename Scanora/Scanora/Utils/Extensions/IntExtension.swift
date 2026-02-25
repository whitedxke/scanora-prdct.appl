import Foundation

extension Optional where Wrapped == Int {
    var orMinusOne: Int {
        self ?? -1
    }
}
