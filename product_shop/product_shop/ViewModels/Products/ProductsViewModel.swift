import Foundation
import Observation

@Observable
final class ProductsViewModel {
    var products: [Product] = []
    var state: ProductsViewState = .idle
    var categories: [String] {
        let uniqueCategories = Set(products.map({ $0.category.capitalized }))
        return ["All"] + uniqueCategories.sorted()
    }

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

            guard let httpResonse = response as? HTTPURLResponse else {
                state = .error("Invalid response")
                return
            }

            guard (200...299).contains(httpResonse.statusCode) else {
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
