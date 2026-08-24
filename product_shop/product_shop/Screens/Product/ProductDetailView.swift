import SDWebImageSwiftUI
import SwiftUI

struct ProductDetailView: View {

    @State private var selectedPage = 0

    private let images = [
        "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/1.webp",
        "https://schonmagazine.com/wp-content/uploads/2025/08/baku-2024-2025-_2555168725-scaled.jpeg",
        "https://cdn.dummyjson.com/product-images/beauty/essence-mascara-lash-princess/1.webp"
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                imageSlider
                pageIndicator
                productInfo
                ratingAndStock
                divider
                descriptionSection
                quantitySection
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 24)
        .navigationTitle("Product Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            favoriteToolbar
        }
    }

    // MARK: - Image Slider

    private var imageSlider: some View {
        TabView(selection: $selectedPage) {
            ForEach(images.indices, id: \.self) { index in
                WebImage(url: URL(string: images[index])) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 258)
                .background(Color(.systemGray6))
                .clipShape(
                    RoundedRectangle(cornerRadius: 24)
                )
                .tag(index)
            }
        }
        .frame(height: 258)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }

    // MARK: - Page Indicator

    private var pageIndicator: some View {
        HStack {
            ForEach(images.indices, id: \.self) { index in
                Capsule()
                    .frame(
                        width: selectedPage == index ? 18 : 8,
                        height: 8
                    )
                    .foregroundStyle(
                        selectedPage == index
                            ? .accentPrimary
                            : .pagerInactive
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 9)
    }

    // MARK: - Product Info

    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("Essence Mascara Lash Princess")
                .foregroundStyle(.textPrimary)
                .font(.system(size: 20, weight: .bold))

            Text("Beauty • Essence")
                .foregroundStyle(.textSecondary)
                .font(.system(size: 12, weight: .medium))
        }
        .padding(.top, 18)
    }

    // MARK: - Rating & Stock

    private var ratingAndStock: some View {
        HStack {
            Text("★ 4.9")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.ratingPrimary)

            Text("(3 reviews)")
                .font(.system(size: 11))
                .foregroundStyle(.textSecondary)

            Spacer()

            Text("In stock: 5")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.successForeground)
                .padding(.horizontal, 25)
                .padding(.vertical, 10)
                .background(.successForeground.opacity(0.15))
                .clipShape(Capsule())
        }
        .padding(.vertical, 16)
    }

    // MARK: - Divider

    private var divider: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundStyle(.divider)
    }

    // MARK: - Description

    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Description")
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.textPrimary)

            Text(
                "A popular mascara known for volumizing and lengthening effects. Long-lasting and cruelty-free."
            )
            .font(.system(size: 12))
            .foregroundStyle(.textSecondary)
            .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 18)
        .padding(.bottom, 45)
    }

    // MARK: - Quantity

    private var quantitySection: some View {
        VStack(alignment: .leading, spacing: 17) {
            Text("Quantity")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.textPrimary)

            quantityControls

            priceAndCart
        }
        .padding(.top, 46)
    }

    private var quantityControls: some View {
        HStack(spacing: 24) {
            quantityButton(systemName: "minus")

            Text("1")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.textPrimary)

            quantityButton(systemName: "plus")
        }
    }

    private func quantityButton(systemName: String) -> some View {
        Button {

        } label: {
            Image(systemName: systemName)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.textPrimary)
                .frame(width: 42, height: 42)
                .background(.surfaceSecondary)
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
        }
    }

    // MARK: - Price & Cart

    private var priceAndCart: some View {
        HStack(alignment: .bottom, spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Price")
                    .font(.system(size: 11))
                    .foregroundStyle(.textSecondary)

                Text("$9.99")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(.accentPrimary)
            }

            Spacer()

            Button {

            } label: {
                Text("Add to Cart")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(.accentPrimary)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
            }
            .frame(maxWidth: 212)
        }
    }

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var favoriteToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                print("test")
            } label: {
                Image(.heartIcon)
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProductDetailView()
    }
}
