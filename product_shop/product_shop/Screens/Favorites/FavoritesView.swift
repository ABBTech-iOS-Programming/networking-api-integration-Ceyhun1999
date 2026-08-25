import SwiftUI

struct FavoritesView: View {

    @Environment(ProductsViewModel.self)
    private var productsViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(productsViewModel.favoriteProducts) { product in
                    ProductCardView(product: product)
                }
            }
            .padding(.horizontal, 24)
        }
        .navigationTitle("Favorites")
    }
}

#Preview {
    FavoritesView()
        .environment(ProductsViewModel())
}
