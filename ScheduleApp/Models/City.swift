import Foundation

struct City: Identifiable, Hashable {
    let id = UUID()
    let name: String
    var stations: [Station]
}
