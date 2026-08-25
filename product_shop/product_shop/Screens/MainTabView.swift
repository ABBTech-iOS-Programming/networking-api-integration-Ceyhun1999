import SwiftUI

struct MainTabView: View {

    @State private var selectedTab: TabItem = .home
    @State private var productsViewModel = ProductsViewModel()

    var body: some View {
        TabView(selection: $selectedTab) {

            Tab(value: .home) {
                HomeView()
            } label: {
                Image(systemName: selectedTab == .home ? "house.fill" : "house")
            }

            Tab(value: .favorites) {
                FavoritesView()
            } label: {
                Image(systemName: selectedTab == .favorites ? "heart.fill" : "heart")
            }

            Tab(value: .cart) {
                Text("Cart")
            } label: {
                Image(systemName: selectedTab == .cart ? "square.fill" : "square")
            }

            Tab(value: .profile) {
                Text("Profile")
            } label: {
                Image(systemName: selectedTab == .profile ? "circle.fill" : "circle")
            }
        }
        .tint(.accentPrimary)
        .environment(productsViewModel)
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
