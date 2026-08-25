import Foundation
import Observation

@Observable
final class ProductsViewModel {

    // MARK: - Properties

    var products: [Product] = []
    var favoriteProductIDs: Set<Int> = []
    var cartProductIDs: Set<Int> = []
    var productQuantities: [Int: Int] = [:]

    var state: ProductsViewState = .idle
    var selectedCategory: String = "All"
    var searchText: String = ""

    // MARK: - Computed Properties

    var favoriteProducts: [Product] {
        products.filter { product in
            favoriteProductIDs.contains(product.id)
        }
    }

    var cartProducts: [Product] {
        products.filter { product in
            cartProductIDs.contains(product.id)
        }
    }

    var categories: [String] {
        let uniqueCategories = Set(
            products.map { $0.category.capitalized }
        )

        return ["All"] + uniqueCategories.sorted()
    }

    var filteredProducts: [Product] {
        products.filter { product in
            (selectedCategory == "All"
                || product.category.capitalized == selectedCategory)
            &&
            (searchText.isEmpty
                || product.title.localizedStandardContains(searchText))
        }
    }

    // MARK: - Favorites

    func isFavorite(_ product: Product) -> Bool {
        favoriteProductIDs.contains(product.id)
    }

    func toggleFavorite(_ product: Product) {
        if favoriteProductIDs.contains(product.id) {
            favoriteProductIDs.remove(product.id)
        } else {
            favoriteProductIDs.insert(product.id)
        }
    }

    // MARK: - Cart

    func addToCart(_ product: Product) {
        cartProductIDs.insert(product.id)
    }

    func removeFromCart(_ product: Product) {
        cartProductIDs.remove(product.id)
    }

    func isInCart(_ product: Product) -> Bool {
        cartProductIDs.contains(product.id)
    }

    func toggleCart(_ product: Product) {
        if cartProductIDs.contains(product.id) {
            cartProductIDs.remove(product.id)
        } else {
            cartProductIDs.insert(product.id)
        }
    }

    // MARK: - Quantity

    func quantity(for product: Product) -> Int {
        productQuantities[product.id] ?? 1
    }

    func increaseQuantity(for product: Product) {
        let currentQuantity = quantity(for: product)

        productQuantities[product.id] = currentQuantity + 1
    }

    func decreaseQuantity(for product: Product) {
        let currentQuantity = quantity(for: product)

        if currentQuantity > 1 {
            productQuantities[product.id] = currentQuantity - 1
        }
    }

    // MARK: - Price

    func discountedPrice(for product: Product) -> Double {
        product.price - (
            product.price * product.discountPercentage / 100
        )
    }

    func totalPrice(for product: Product) -> Double {
        product.price * Double(quantity(for: product))
    }

    func discountedTotalPrice(for product: Product) -> Double {
        discountedPrice(for: product)
            * Double(quantity(for: product))
    }

    // MARK: - Networking

    func fetchPosts() async {
        state = .loading

        let urlString = "https://dummyjson.com/products"

        guard let url = URL(string: urlString) else {
            state = .error("Invalid url")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(
                for: request
            )

            guard let httpResponse = response as? HTTPURLResponse else {
                state = .error("Invalid response")
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                state = .error("Server xetasi")
                return
            }

            let decodedData = try JSONDecoder().decode(
                ProductResponse.self,
                from: data
            )

            products = decodedData.products
            state = products.isEmpty ? .empty : .loaded

        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
