import SwiftUI

struct CartView: View {

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
                if productsViewModel.cartProducts.isEmpty {
                    EmptyStateView(
                        title: "Cart is empty",
                        systemImage: "cart",
                        description: "Your added products will appear here"
                    )
                } else {
                    cartGrid
                }
            }
        }
        .navigationTitle("Cart")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Background

    private var backgroundView: some View {
        Color(.backgroundPrimary)
            .ignoresSafeArea()
    }

    // MARK: - Cart Grid

    private var cartGrid: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(productsViewModel.cartProducts) { product in
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
    NavigationStack {
        CartView()
    }
    .environment(ProductsViewModel())
}
