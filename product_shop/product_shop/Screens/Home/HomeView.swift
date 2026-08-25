import SwiftUI

struct HomeView: View {

    // MARK: - Environment

    @Environment(ProductsViewModel.self)
    private var productsViewModel

    // MARK: - State

    @FocusState private var isSearchFocused: Bool

    // MARK: - Properties

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible()),
    ]

    // MARK: - Body

    var body: some View {
        ZStack {
            backgroundView

            VStack(spacing: 20) {
                heroSection
                searchBar
                categoriesList
                content
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal, 24)
        }
        .task {
            await productsViewModel.fetchPosts()
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        switch productsViewModel.state {
        case .idle, .loading:
            ProgressView("Loading")

        case .loaded:
            if productsViewModel.filteredProducts.isEmpty {
                productsNotFoundView
            } else {
                productsScrollView
            }

        case .empty:
            emptyProductsView

        case .error(let message):
            errorView(message)
        }
    }

    // MARK: - Products Not Found

    private var productsNotFoundView: some View {
        ContentUnavailableView {
            Label(
                "Products not found",
                systemImage: "magnifyingglass"
            )
        } description: {
            Text("Try changing your search or category")
        }
    }

    // MARK: - Empty Products

    private var emptyProductsView: some View {
        ContentUnavailableView {
            Label(
                "Yenidən cəhd elə",
                systemImage: "exclamationmark.triangle"
            )
        } description: {
            Text("No products")
        }
    }

    // MARK: - Error

    private func errorView(_ message: String) -> some View {
        ContentUnavailableView {
            Label(
                "Yenidən cəhd elə",
                systemImage: "exclamationmark.triangle"
            )
        } description: {
            Text(message)
        } actions: {
            Button("Try again") {
                Task {
                    await productsViewModel.fetchPosts()
                }
            }
        }
    }

    // MARK: - Products

    private var productsScrollView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            productsGrid
        }
        .refreshable {
               await productsViewModel.fetchPosts()
           }
    }

    private var productsGrid: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(productsViewModel.filteredProducts) { product in
                NavigationLink {
                    ProductDetailView(
                        product: product
                    )
                } label: {
                    ProductCardView(product: product)
                }
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
        .frame(maxWidth: .infinity, alignment: .leading)
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

    // MARK: - Search

    private var searchBar: some View {
        @Bindable var productsViewModel = productsViewModel

        return HStack(spacing: 20) {
            Image(.searchIcon)
                .frame(width: 16)

            TextField(
                "Search products",
                text: $productsViewModel.searchText
            )
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
                ForEach(
                    productsViewModel.categories,
                    id: \.self
                ) { category in
                    categoryButton(category)
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - Category Button

    private func categoryButton(_ categoryName: String) -> some View {
        Button {
            productsViewModel.selectedCategory = categoryName
        } label: {
            Text(categoryName)
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(
                    productsViewModel.selectedCategory == categoryName
                        ? .white
                        : .textPrimary
                )
                .padding(.horizontal, 25)
                .padding(.vertical, 12)
                .background(
                    productsViewModel.selectedCategory == categoryName
                        ? .accentPrimary
                        : .surfaceSecondary
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environment(ProductsViewModel())
}
