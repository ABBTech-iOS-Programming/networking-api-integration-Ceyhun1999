import Foundation
import Observation

@Observable
final class ProductsViewModel {

    // MARK: - Properties

    var products: [Product] = []
    var favoriteProducts: [Product] = []
    var cartProducts: [Product] = []
    var productQuantities: [Int: Int] = [:]

    var state: ProductsViewState = .idle
    var selectedCategory: String = "All"
    var searchText: String = ""
    var categories: [String] = []

    // MARK: - Computed Properties

    var filteredProducts: [Product] {
        products.filter { product in
            searchText.isEmpty
                || product.title.localizedStandardContains(searchText)
        }
    }

    // MARK: - Favorites

    func isFavorite(_ product: Product) -> Bool {
        favoriteProducts.contains { favoriteProduct in
            favoriteProduct.id == product.id
        }
    }

    func toggleFavorite(_ product: Product) {
        if isFavorite(product) {
            favoriteProducts.removeAll { favoriteProduct in
                favoriteProduct.id == product.id
            }
        } else {
            favoriteProducts.append(product)
        }
    }

    // MARK: - Cart

    func addToCart(_ product: Product) {
        if isInCart(product) {
            return
        }

        cartProducts.append(product)
    }

    func removeFromCart(_ product: Product) {
        cartProducts.removeAll { cartProduct in
            cartProduct.id == product.id
        }
    }

    func isInCart(_ product: Product) -> Bool {
        cartProducts.contains { cartProduct in
            cartProduct.id == product.id
        }
    }

    func toggleCart(_ product: Product) {
        if isInCart(product) {
            removeFromCart(product)
        } else {
            addToCart(product)
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

    func fetchCategories() async {
        let urlString = "https://dummyjson.com/products/category-list"

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
                [String].self,
                from: data
            )

            categories = ["All"] + decodedData.map { $0.capitalized }

        } catch {
            state = .error(error.localizedDescription)
        }
    }

    func fetchProducts(for category: String) async {
        state = .loading

        let urlString: String

        if category == "All" {
            urlString = "https://dummyjson.com/products?limit=0"
        } else {
            urlString = "https://dummyjson.com/products/category/\(category.lowercased())"
        }

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
