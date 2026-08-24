import SwiftUI

struct HomeView: View {

    // MARK: - State

    @State private var searchText = ""
    @State private var selectedCategory = "All"

    @FocusState private var isSearchFocused: Bool

    // MARK: - Properties

    private let categories = [
        "All",
        "Beauty",
        "Home",
        "Tech",
        "Alld",
        "Beautysf",
        "Homesd",
        "Techfsf",
    ]

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible()),
    ]

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundView

                VStack(spacing: 20) {
                    heroSection
                    searchBar
                    categoriesList

                    ScrollView(.vertical, showsIndicators: false) {
                        NavigationLink {
                            ProductDetailView()
                        } label: {
                            productsGrid
                        }

                    }
                }
                .padding(24)
            }
        }
    }

    private var productsGrid: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<6) { index in
                ProductCardView()
            }
        }
    }

    // MARK: - Background

    private var backgroundView: some View {
        Color(.backgroundPrimary)
            .ignoresSafeArea()
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        HStack(alignment: .top) {
            heroText

            Spacer()

            discountBadge
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(.heroBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: 22)
        )
    }

    // MARK: - Hero Text

    private var heroText: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("Good morning")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.textOnHeroMuted)

            Text("Find your next favorite product")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)

            Text("Fresh picks for you")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(.textOnHeroAccent)
        }
        .frame(alignment: .leading)
    }

    // MARK: - Discount Badge

    private var discountBadge: some View {
        Text("20% OFF")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 13)
            .padding(.vertical, 6)
            .background(.accentPrimary)
            .clipShape(Capsule())
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 20) {
            Image(.searchIcon)
                .frame(width: 16)

            TextField("Search products", text: $searchText)
                .focused($isSearchFocused)
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .frame(height: 52)
        .background(.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 16)
        )
        .contentShape(
            RoundedRectangle(cornerRadius: 16)
        )
        .onTapGesture {
            isSearchFocused = true
        }
    }

    // MARK: - Categories

    private var categoriesList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    categoryButton(category)
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    

    // MARK: - Category Button

    private func categoryButton(_ categoryName: String) -> some View {
        Button {
            selectedCategory = categoryName
        } label: {
            Text(categoryName)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(
                    selectedCategory == categoryName
                        ? .white
                        : .textPrimary
                )
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .background(
                    selectedCategory == categoryName
                        ? .accentPrimary
                        : .surfaceSecondary
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
}
