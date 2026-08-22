import Foundation

struct Product: Identifiable {

    let id = UUID()

    let name: String
    let brand: String
    let category: String

    let price: Double

    let rating: Double
    let reviewsCount: Int

    let stock: Int

    let description: String

    let images: [String]
}
