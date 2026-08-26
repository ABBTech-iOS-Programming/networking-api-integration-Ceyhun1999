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
        ZStack {
            backgroundView

            Group {
                if productsViewModel.favoriteProducts.isEmpty {
                    EmptyStateView(
                        title: "No favorites",
                        systemImage: "heart.slash",
                        description: "Your favorite products will appear here"
                    )
                } else {
                    favoritesGrid
                }
            }
        }
        
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Background

    private var backgroundView: some View {
        Color(.backgroundPrimary)
            .ignoresSafeArea()
    }

    // MARK: - Favorites Grid

    private var favoritesGrid: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(productsViewModel.favoriteProducts) { product in
                    NavigationLink(
                        value: Route.productDetail(product: product)
                    ) {
                        ProductCardView(product: product)
                    }
                    .buttonStyle(.plain)
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
