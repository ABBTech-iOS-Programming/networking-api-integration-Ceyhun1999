import Foundation

struct ProductResponse: Decodable, Hashable {
    let products: [Product]
}

struct Product: Decodable, Identifiable, Hashable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let discountPercentage: Double
    let price: Double
    let rating: Double
    let stock: Int
    let brand: String?
    let images: [String]
    let thumbnail: String
    let reviews: [Review]
}

struct Review: Codable, Hashable {
    let rating: Int
}
