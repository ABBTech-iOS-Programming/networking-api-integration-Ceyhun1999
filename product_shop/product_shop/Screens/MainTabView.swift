import SwiftUI

struct MainTabView: View {

    // MARK: - State

    @State private var selectedTab: TabItem = .home

    @State private var productsViewModel = ProductsViewModel()

    @State private var homeNavigationViewModel = NavigationViewModel()
    @State private var favoritesNavigationViewModel = NavigationViewModel()
    @State private var cartNavigationViewModel = NavigationViewModel()

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTab) {

            // MARK: Home

            Tab(value: .home) {
                NavigationStack(path: $homeNavigationViewModel.path) {
                    HomeView()
                        .navigationDestination(for: Route.self) { route in
                            homeNavigationViewModel.destination(for: route)
                        }
                }
                .environment(homeNavigationViewModel)
            } label: {
                Image(
                    systemName: selectedTab == .home
                        ? "house.fill"
                        : "house"
                )
            }

            // MARK: Favorites

            Tab(value: .favorites) {
                NavigationStack(path: $favoritesNavigationViewModel.path) {
                    FavoritesView()
                        .navigationDestination(for: Route.self) { route in
                            favoritesNavigationViewModel.destination(for: route)
                        }
                }
                .environment(favoritesNavigationViewModel)
            } label: {
                Image(
                    systemName: selectedTab == .favorites
                        ? "heart.fill"
                        : "heart"
                )
            }

            // MARK: Cart

            Tab(value: .cart) {
                NavigationStack(path: $cartNavigationViewModel.path) {
                    CartView()
                        .navigationDestination(for: Route.self) { route in
                            cartNavigationViewModel.destination(for: route)
                        }
                }
                .environment(cartNavigationViewModel)
            } label: {
                Image(
                    systemName: selectedTab == .cart
                        ? "square.fill"
                        : "square"
                )
            }

            // MARK: Profile

            Tab(value: .profile) {
                NavigationStack {
                    Text("Profile")
                        .navigationTitle("Profile")
                }
            } label: {
                Image(
                    systemName: selectedTab == .profile
                        ? "circle.fill"
                        : "circle"
                )
            }
        }
        .tint(.accentPrimary)
        .environment(productsViewModel)
    }
}

// MARK: - Tab Item

private enum TabItem {
    case home
    case favorites
    case cart
    case profile
}

#Preview {
    MainTabView()
}
