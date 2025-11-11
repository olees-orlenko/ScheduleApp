import Foundation

struct Story: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let isSeen: Bool
}
