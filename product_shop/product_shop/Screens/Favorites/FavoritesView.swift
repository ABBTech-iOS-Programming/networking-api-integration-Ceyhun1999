import SwiftUI

struct FavoritesView: View {

    // MARK: - Environment

    @Environment(ProductsViewModel.self)
    private var productsViewModel

    // MARK: - Properties

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible()),
    ]

    // MARK: - Body

    var body: some View {
        Group {
            if productsViewModel.favoriteProducts.isEmpty {
                emptyState
            } else {
                favoritesGrid
            }
        }
        .navigationTitle("Favorites")
    }

    // MARK: - Empty State

    private var emptyState: some View {
        ContentUnavailableView {
            Label(
                "No favorites",
                systemImage: "heart.slash"
            )
        } description: {
            Text("Your favorite products will appear here")
        }
    }

    // MARK: - Favorites Grid

    private var favoritesGrid: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(productsViewModel.favoriteProducts) { product in
                    ProductCardView(product: product)
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    FavoritesView()
        .environment(ProductsViewModel())
}
