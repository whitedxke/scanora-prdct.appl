import Foundation

enum ApplicationViewState<T> {
    case idle
    case loading
    case empty
    case success(T)
    case error(String)
}
