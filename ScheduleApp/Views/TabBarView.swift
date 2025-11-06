import SwiftUI

struct TabBarView: UIViewControllerRepresentable {
    typealias UIViewControllerType = TabBarController

    func makeUIViewController(context: Context) -> TabBarController {
        let tabBarController = TabBarController()
        return tabBarController
    }

    func updateUIViewController(_ uiViewController: TabBarController, context: Context) {
    }
}
