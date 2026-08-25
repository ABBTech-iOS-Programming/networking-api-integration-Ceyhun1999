import SwiftUI

struct HomeView: View {

    // MARK: - State

    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var navigationViewModel = NavigationViewModel()

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
        "Techfsf"
    ]

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible())
    ]

    private let mockProduct = Product(
        name: "ad",
        brand: "ad",
        category: "ad",
        price: 2,
        rating: 2,
        reviewsCount: 2,
        stock: 2,
        description: "ad",
        images: ["ad", "ad"]
    )

    // MARK: - Body

    var body: some View {
        NavigationStack(path: $navigationViewModel.path) {
            ZStack {
                backgroundView

                VStack(spacing: 20) {
                    heroSection
                    searchBar
                    categoriesList
                    productsScrollView
                }
                .padding(.horizontal , 24)
            }
            .navigationDestination(for: Route.self) { route in
                navigationViewModel.destination(for: route)
            }
        }
    }

    // MARK: - Products

    private var productsScrollView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            productsGrid
        }
    }

    private var productsGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(0..<6, id: \.self) { _ in
                productButton
            }
        }
    }

    private var productButton: some View {
        Button {
            openProductDetail()
        } label: {
            ProductCardView()
        }
        .buttonStyle(.plain)
    }

    // MARK: - Navigation

    private func openProductDetail() {
        navigationViewModel.navigate(
            to: .productDetail(product: mockProduct)
        )
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
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var discountBadge: some View {
        Text("20% OFF")
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.white)
            .padding(.horizontal, 13)
            .padding(.vertical, 6)
            .background(.accentPrimary)
            .clipShape(Capsule())
    }

    // MARK: - Search

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
