import Foundation
import Observation

@Observable
final class ProductsViewModel {

    // MARK: - Properties

    var products: [Product] = []
    var favoriteProductIDs: Set<Int> = []
    var state: ProductsViewState = .idle
    var selectedCategory: String = "All"
    var searchText: String = ""

    // MARK: - Computed Properties

    var favoriteProducts: [Product] {
        products.filter { product in
            favoriteProductIDs.contains(product.id)
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
