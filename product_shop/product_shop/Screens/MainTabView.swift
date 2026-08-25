import SwiftUI

struct MainTabView: View {

    @State private var selectedTab: TabItem = .home
    @State private var productsViewModel = ProductsViewModel()
    @State private var navigationViewModel = NavigationViewModel()

    var body: some View {
        NavigationStack(path: $navigationViewModel.path) {
            TabView(selection: $selectedTab) {
                Tab(value: .home) {
                    HomeView()
                } label: {
                    Image(
                        systemName: selectedTab == .home
                            ? "house.fill"
                            : "house"
                    )
                }

                Tab(value: .favorites) {
                    FavoritesView()
                } label: {
                    Image(
                        systemName: selectedTab == .favorites
                            ? "heart.fill"
                            : "heart"
                    )
                }

                Tab(value: .cart) {
                    Text("Cart")
                } label: {
                    Image(
                        systemName: selectedTab == .cart
                            ? "square.fill"
                            : "square"
                    )
                }

                Tab(value: .profile) {
                    Text("Profile")
                } label: {
                    Image(
                        systemName: selectedTab == .profile
                            ? "circle.fill"
                            : "circle"
                    )
                }
            }
            .tint(.accentPrimary)
          
            .navigationDestination(for: Route.self) { route in
                navigationViewModel.destination(for: route)
            }
        }
        .environment(productsViewModel)
        .environment(navigationViewModel)
    }
}

private enum TabItem {
    case home
    case favorites
    case cart
    case profile
}

#Preview {
    MainTabView()
}
