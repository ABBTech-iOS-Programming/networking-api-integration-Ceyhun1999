import SwiftUI

struct ProductCardView: View {

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
            Image(.testProductImage2)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 108)
                .clipped()
                .clipShape(
                    RoundedRectangle(cornerRadius: 14)
                )

            Text("★ 4.9")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.ratingPrimary)
                .padding(14)
        }
    }

    // MARK: - Product Info

    private var productInfo: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Mascara Lash")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.textPrimary)

            Text("Essence")
                .font(.system(size: 10, weight: .regular))
                .foregroundStyle(.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Bottom Section

    private var bottomSection: some View {
        HStack {
            Text("$14.99")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.textPrimary)

            Spacer()

            addButton
        }
    }

    // MARK: - Add Button

    private var addButton: some View {
        Button {
            print("test")
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
    ProductCardView()
}
