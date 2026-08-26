import SDWebImageSwiftUI
import SwiftUI

struct ProductCardView: View {

    // MARK: - Environment

    @Environment(ProductsViewModel.self)
    private var productsViewModel

    // MARK: - Properties

    let product: Product

    // MARK: - Body

    var body: some View {
        VStack(spacing: 10) {
            productImage
            productInfo
            bottomSection
        }
        .padding(
            EdgeInsets(
                top: 6,
                leading: 6,
                bottom: 12,
                trailing: 6
            )
        )
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 18)
        )
    }

    // MARK: - Product Image

    private var productImage: some View {
        ZStack(alignment: .topLeading) {
            WebImage(
                url: URL(string: product.thumbnail)
            ) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 108)
            .background(Color(.systemGray6))
            .clipped()
            .clipShape(
                RoundedRectangle(cornerRadius: 14)
            )

            Text("★ \(product.rating, specifier: "%.1f")")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.ratingPrimary)
                .padding(14)
        }
    }

    // MARK: - Product Info

    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(product.title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.textPrimary)
                .multilineTextAlignment(.leading)

            Text(product.brand ?? product.category.capitalized)
                .font(.system(size: 10, weight: .regular))
                .foregroundStyle(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Bottom Section

    private var bottomSection: some View {
        HStack {
            Text("$\(product.price, specifier: "%.2f")")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.textPrimary)

            Spacer()

            addButton
        }
    }

    // MARK: - Add Button

    private var addButton: some View {
        Button {
            productsViewModel.addToCart(product)
        } label: {
            Image(.plusIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 13, height: 13)
                .frame(width: 30, height: 30)
                .background(.accentPrimary)
                .clipShape(
                    RoundedRectangle(cornerRadius: 10)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ProductCardView(
        product: Product(
            id: 1,
            title: "Essence Mascara Lash Princess",
            description: "The Essence Mascara Lash Princess is a popular mascara known for its volumizing and lengthening effects.",
            category: "beauty",
            discountPercentage: 5,
            price: 9.99,
            rating: 2.56,
            stock: 99,
            brand: "Essence",
            images: [
                "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/1.webp"
            ],
            thumbnail: "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/thumbnail.webp",
            reviews: [
                Review(rating: 3),
                Review(rating: 4),
                Review(rating: 5),
            ]
        )
    )
    .environment(ProductsViewModel())
}
