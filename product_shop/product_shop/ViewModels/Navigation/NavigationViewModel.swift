import Observation
import SwiftUI

enum Route: Hashable {
    case productDetail(product: Product)
}

@Observable
final class NavigationViewModel {

    var path = NavigationPath()

    func navigate(to route: Route) {
        path.append(route)
    }

    func back() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    @ViewBuilder
    func destination(for route: Route) -> some View {
        switch route {
        case .productDetail(let product):
            ProductDetailView(product: product)
        }
    }
}
