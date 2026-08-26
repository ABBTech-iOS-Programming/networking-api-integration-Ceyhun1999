import SwiftUI

struct EmptyStateView: View {

    // MARK: - Properties

    let title: String
    let systemImage: String
    let description: String

    // MARK: - Body

    var body: some View {
        ContentUnavailableView {
            Label(
                title,
                systemImage: systemImage
            )
        } description: {
            Text(description)
        }
    }
}

struct ErrorStateView: View {

    // MARK: - Properties

    let title: String
    let systemImage: String
    let description: String
    let retryAction: () -> Void

    // MARK: - Body

    var body: some View {
        ContentUnavailableView {
            Label(
                title,
                systemImage: systemImage
            )
        } description: {
            Text(description)
        } actions: {
            Button("Try again") {
                retryAction()
            }
        }
    }
}

#Preview {
    EmptyStateView(
        title: "No products",
        systemImage: "exclamationmark.triangle",
        description: "No products"
    )
}
