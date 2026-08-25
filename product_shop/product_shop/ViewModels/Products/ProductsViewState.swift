import Foundation

enum ProductsViewState {
    case idle
    case loading
    case loaded
    case empty
    case error(String)
}
